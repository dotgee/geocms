require "geocms/backend"
require 'net/http'
require 'open-uri'
require 'fileutils'

# integer for count news or/and updates layers
$cpt_new=0;
$cpt_update=0;

# search layer info
# @param node <Nokogiri::XML::NodeSet>
# @param search <string>
# @param source_id <integer> id of data_source
def getLayerInfo(node,search,source_id)
  if !node.nil?
    layers=node.search(search)
    if !layers.empty?
      # for each layer in node_set
      layers.each do |layer|
        # search name, description, title and metadata_url
        name=layer.search("> Name").first
        if !name.nil?
          description = layer.search("> Abstract").first;
          title = layer.search("> Title").first;
          metadataUrl=layer.search("> MetadataURL > OnlineResource").first

          description= !description.nil? ? description.content : nil
          title= !title.nil? ? title.content : nil
          metadataUrl= !metadataUrl.nil? ? metadataUrl["xlink:href"] : nil

          # searche layer if exist
          layerFromBdd=Geocms::Layer.where(name: name.content).take
          if !layerFromBdd.nil?
            update=false;
            if title != layerFromBdd.title
            layerFromBdd.title=title;
            update=true
            end
            if description != layerFromBdd.description
              layerFromBdd.description=description;
              update=true
            end
            if metadataUrl != layerFromBdd.metadata_url
              layerFromBdd.metadata_url=metadataUrl;
              update=true
            end
            if update
              $cpt_update = $cpt_update+1
            end
            # update layer
            date=DateTime.now.strftime("%F %T UTC")
            layerFromBdd.updated_at = date
            layerFromBdd.save
          elsif !title.nil? && title!=""
            date=DateTime.now.strftime("%F %T UTC")
            newLayer = Geocms::Layer.create(
              name: name.content,
              title: title,
              description: description,
              metadata_url: metadataUrl,
              updated_at: date,
              created_at: date,
              data_source_id:source_id
            )
            #create layer
            newLayer.save!
            $cpt_new = $cpt_new+1
          end
        end
        # for other layer in layer
        getLayerInfo(layer," > Layer",source_id)
      end
    end
  end
end
################################
##            TASK            ##
################################
namespace :geocms do
  namespace :synchro do
    desc "Synchronization source"
    task :wms => :environment  do
      #init directory and log files
      date=DateTime.now.strftime("%Y%m%d_%H%M");

      if !File.directory?("log/update")
        FileUtils::mkdir_p 'log/update'
      end

      path="log/update/"
      filename="data_update_"+date.to_s
      logFile=filename+".log"

      #Open log file
      File.open(path+logFile, "w+") do |f|
        # for each datas sources
        Geocms::DataSource.where(synchro: true).all.each do |source|
          f << "-------------------------------------------------------------------------------\n"
          f << "Nom de la source : " << source.name << "\n"
          print( "Nom de la source : ",source.name,"\n")
          begin
            xml_doc  = Nokogiri::XML(open(source.wms+"?SERVICE=WMS&VERSION="+source.wms_version+"&REQUEST=GetCapabilities"))

            $cpt_update=0;
            $cpt_new=0;
            date=DateTime.now.strftime("%F %T UTC");

            # update layer
            getLayerInfo(xml_doc,"Capability > Layer",source.id);
            f << "Date de mise à jour : " << date << "\n"
            f << "Nombre de layer mis à jour : " << $cpt_update <<  "\n"
            f << "Nombre de nouveau layer : " << $cpt_new << "\n"

            # delete layer not update
            compteur_delete=0
            sql = Geocms::Layer.where("updated_at < :updated_date and data_source_id = :data_source_id",{
              updated_date: date,
              data_source_id: source.id
            }).all.each  do |layer|
              layer.destroy
              compteur_delete = compteur_delete + 1
            end
            f << "Nombre de layer suprimmé : "  << compteur_delete << "\n"
            compteur_delete=0;
            sql2= Geocms::Categorization.joins("left join geocms_layers on geocms_layers.id = geocms_categorizations.layer_id ").where("geocms_layers.id is null").all.each do |result|
              Geocms::Categorization.delete_all(layer_id: result.layer_id)
              compteur_delete = compteur_delete + 1
            end
            f << "Nombre de relation layer/catégorie suprimmé : "  << compteur_delete  << "\n"

          rescue => e
            f  << "Error : "  << e  << "\n"
          end
        end
      end
      # send email to admins_data users
      puts "search admin user : "
      Geocms::User.joins(:roles).where(geocms_roles: { name: 'admin' }).all.each do |user|;
        print("Send mail to : ", user.username ,"\n")
        UserMailer.sendUpdateLog(filename,date,user)
      end
    end
  end
end
