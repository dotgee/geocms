xml.instruct!
xml.ViewContext(:id => @context.uuid, :version => "1.1.0", "xmlns" => "http://www.opengis.net/context", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.opengis.net/context http://schemas.opengis.net/context/1.1.0/context.xsd") do
  xml.General do
    xml.BoundingBox(:SRS => current_tenant.crs.value, :maxx => @context.maxx, :maxy => @context.maxy, :minx => @context.minx, :miny => @context.miny)
    xml.Title @context.name
    xml.Extension do
      xml.tag!("ol:maxExtent", :maxx => @context.maxx, :maxy => @context.maxy, :minx => @context.minx, :miny => @context.miny, "xmlns:ol" => "http://openlayers.org/context")
    end
  end
  xml.LayerList do
    xml.Layer( :hidden => "0", :queryable => "0" ) do
      xml.Server(:service => "OGC:WMS", :version => "1.1.1") do
        xml.OnlineResource("xlink:href" => "http://osm.geobretagne.fr/gwc01/service/wms", "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
      end
      xml.Name "imposm:google"
      xml.Title "OpenStreetMap"
      xml.Abstract "carte OpenStreetMap licence CreativeCommon by-SA"
      xml.MetadataURL do
        xml.OnlineResource("xlink:href" => "http://wiki.openstreetmap.org/wiki/FR:OpenStreetMap_License", "xlink:type" => "simple", "xmlns:xlink" => "http://www.w3.org/1999/xlink")
      end
      xml.FormatList do
        xml.Format("image/png", :current => 1)
      end
      xml.Extension do
  if current_tenant.crs.value == "EPSG:2154"
    xml.tag!("ol:maxExtent", :maxx => "2146865.30590000004", :maxy => "8541697.23630000092", :minx => "-357823.236499999999", :miny => "6037008.69390000030", "xmlns:ol" => "http://openlayers.org/context")
  else
    xml.tag!("ol:maxExtent", :maxx => "1", :maxy => "1", :minx => "-1", :miny => "-1", "xmlns:ol" => "http://openlayers.org/context")
  end
        xml.tag!("ol:numZoomLevels", 17, "xmlns:ol" => "http://openlayers.org/context")
        xml.tag!("ol:tileSize", :height => "256", :width => "256", "xmlns:ol" => "http://openlayers.org/context")
        xml.tag!("ol:units", "m", "xmlns:ol" => "http://openlayers.org/context")
        xml.tag!("ol:isBaseLayer", "false", "xmlns:ol" => "http://openlayers.org/context")
        xml.tag!("ol:displayInLayerSwitcher", "true", "xmlns:ol" => "http://openlayers.org/context")
        xml.tag!("ol:singleTile", "true", "xmlns:ol" => "http://openlayers.org/context")
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
          bbox = layer.boundingbox(current_tenant)
          xml.tag!("ol:maxExtent", :maxx => bbox[1], :maxy => bbox[2], :minx => bbox[2], :miny => bbox[3], "xmlns:ol" => "http://openlayers.org/context")
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