xml.instruct!
xml.ViewContext(:id => @context.uuid, :version => "1.1.0", "xmlns" => "http://www.opengis.net/context", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.opengis.net/context http://schemas.opengis.net/context/1.1.0/context.xsd") do
  xml.General do
    xml.BoundingBox(:SRS => @crs, :maxx => @point_max[0], :maxy => @point_max[1], :minx => @point_min[0], :miny => @point_min[1])
    xml.Title @context.name
    xml.Extension do
      xml.tag!("ol:maxExtent", :minx => @bounding_box[0], :miny => @bounding_box[1], :maxx => @bounding_box[2], :maxy => @bounding_box[3], "xmlns:ol" => "http://openlayers.org/context")
    end
  end
  xml.LayerList do
      xml.Layer( :hidden => "0", :queryable => "0" ) do
        if @crs == "EPSG:2154"
          xml.Server(:service => "OGC:WMS", :version => "1.1.1") do
            xml.OnlineResource("xlink:href" => "http://osm.geobretagne.fr/gwc01/service/wms", "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
          end
          xml.Name "osm:google"
        elsif @crs == "EPSG:3857"
          xml.Server(:service => "OGC:WMS", :version => "1.1.1") do
              xml.OnlineResource("xlink:href" => "http://129.206.228.72/cached/osm", "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
          end
          xml.Name "osm_auto:all"
        end
        xml.Title "OpenStreetMap"
        xml.Abstract "carte OpenStreetMap licence CreativeCommon by-SA"
        xml.MetadataURL do
          xml.OnlineResource("xlink:href" => "http://wiki.openstreetmap.org/wiki/FR:OpenStreetMap_License", "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
        end
        xml.FormatList do
          xml.Format("image/png", :current => 1)
        end
        xml.Extension do
          xml.tag!("ol:maxExtent", :minx => @point_min[0], :miny => @point_min[1], :maxx => @point_max[0], :maxy => @point_max[1], "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:numZoomLevels", 22, "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:tileSize", :height => "256", :width => "256", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:units", "m", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:isBaseLayer", "true", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:displayInLayerSwitcher", "true", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:singleTile", "false", "xmlns:ol" => "http://openlayers.org/context")
        end
      end
    @context.layers.each do |layer|
      xml.Layer( :hidden => "0", :queryable => "1" ) do
        xml.Server(:service => "OGC:WMS", :version => "1.1.1") do
          xml.OnlineResource("xlink:href" => layer.data_source_wms , "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
        end
        xml.Name layer.name
        xml.Title layer.title
        xml.Abstract layer.description
        xml.MetadataURL do
          xml.OnlineResource("xlink:href" => layer.metadata_url, "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
        end
        xml.StyleList do
          xml.Style do
            xml.Name
            xml.Title
          end
        end
        xml.FormatList do
          xml.Format("image/png", :current => 1)
        end
        xml.Extension do
          bbox = layer.boundingbox

          if bbox.nil?
            p_min = [@bounding_box[0], @bounding_box[1]]
            p_max = [@bounding_box[2], @bounding_box[3]]
          else
            p_min = Geocms::ProjectionConverter.new(@crs, [bbox[0], bbox[1]]).project
            p_max = Geocms::ProjectionConverter.new(@crs, [bbox[2], bbox[3]]).project
          end

          xml.tag!("ol:maxExtent", :maxx => p_max[0], :maxy => p_max[1], :minx => p_min[0], :miny => p_min[1], "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:numZoomLevels", 17, "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:tileSize", :height => "256", :width => "256", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:units", "m", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:isBaseLayer", "false", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:transparent", "true", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:displayInLayerSwitcher", "true", "xmlns:ol" => "http://openlayers.org/context")
          xml.tag!("ol:singleTile", "false", "xmlns:ol" => "http://openlayers.org/context")
        end
      end
    end
  end
end