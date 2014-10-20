function OLMap()
{
}

OLMap.prototype.init = function(divName, markerPath)
{
   	OpenLayers.Lang.setCode("ru");
	OpenLayers.IMAGE_RELOAD_ATTEMPTS = 5;

	this.map = new OpenLayers.Map(
    {
        div: divName,
       	projection: new OpenLayers.Projection("EPSG:102100"),
		controls: []
    });

	//this.map.addControl(new OpenLayers.Control.LayerSwitcher());
    this.map.addControl(new OpenLayers.Control.Navigation());

	//var mapLayer = new OpenLayers.Layer.OSM();

	mapLayer = new OpenLayers.Layer.Google(name, {
		type: google.maps.MapTypeId.ROADMAP,numZoomLevels: 23, MAX_ZOOM_LEVEL: 22});

	this.map.addLayer(mapLayer);

	this.pathLayer = this.createLineLayer("Путь", "#ff0000", "#550000", 0.1);
	this.markerLayer = this.createMarkerLayer("ТС", markerPath);

    this.map.setCenter(this.newLonLat(65, 95), 3);




  	//this.createVectorLayers();

  	//this.addCustomControls();

  	//this.addLayersMenu();
}

OLMap.prototype.createLineLayer = function(name, lineColor, fillColor, fillOp)
{
	var options =
	{
		styleMap: new OpenLayers.StyleMap(
		{
	        strokeWidth: 0.6,
	        fillOpacity: fillOp,
	        strokeOpacity: 0.6,
	        strokeLinecap: "round",
	        strokeColor: lineColor,
	        fillColor:fillColor
		})
	};
	var layer = new OpenLayers.Layer.Vector(name, options);
 	this.map.addLayers([layer]);
 	return layer;
}

OLMap.prototype.createMarkerLayer = function(name, markerPath)
{
	var options =
	{
		styleMap: new OpenLayers.StyleMap(
		{
	       graphicName: "circle",
	  	pointRadius: 13,
	  	strokeWidth: 10,
	  	fillOpacity: 0.6,
	  	strokeOpacity: 0.3,
	  	strokeLinecap: "round",

	  	strokeColor: "yellow",
	  	fillColor: "yellow",

		})
	};
	var layer = new OpenLayers.Layer.Vector(name, options);


 	this.map.addLayers([layer]);
 	return layer;


 /*	var markers = new OpenLayers.Layer.Markers( "Markers" );
    this.map.addLayer(markers);
    return markers;  */
}


OLMap.prototype.newPnt = function(lat, lon)
{
    var pnt = new OpenLayers.Geometry.Point(lon, lat);
    pnt = pnt.transform( new OpenLayers.Projection("EPSG:4326"),
        this.map.getProjectionObject());
    return pnt;
}

OLMap.prototype.newLonLat = function(lat, lon)
{
    var lonlat = new OpenLayers.LonLat(lon, lat);

    return lonlat.transform( new OpenLayers.Projection("EPSG:4326"),
        this.map.getProjectionObject());
}

OLMap.prototype.pathStyle =
{
		strokeColor: "blue",
		strokeOpacity: 0.6,
    	strokeWidth: 3
}

OLMap.prototype.carStyle =
{
	       externalGraphic: "truck.png",
        graphicWidth: 21,
    	graphicHeight: 21,
}
OLMap.prototype.drawPath = function(coords)
{
	var points = [];
	for(var i in coords)
	{
 		points.push(this.newPnt(coords[i].lat, coords[i].lon));
 	}
	var line = new OpenLayers.Geometry.LineString(points);
	var lineFeature = new OpenLayers.Feature.Vector(line, null, this.pathStyle);
	this.pathLayer.addFeatures([lineFeature]);
	this.map.zoomToExtent(line.getBounds());




    this.carFeature = new OpenLayers.Feature.Vector(points[points.length-1], null, this.carStyle);

	this.markerLayer.addFeatures([this.carFeature]);
	this.markerLayer.redraw();

	return line.getGeodesicLength(new OpenLayers.Projection("EPSG:900913"))/1000;

}

OLMap.prototype.continuePath = function(coords)
{
	if(coords.length == 0) return;

  	var geometry = this.pathLayer.features[0].geometry;
	for(var i in coords) geometry.addPoint(this.newPnt(coords[i].lat, coords[i].lon));
 	this.pathLayer.redraw();
 //	var pnt =  this.newPnt(coords[coords.length-1].lat, coords[coords.length-1].lon);
 //	this.carFeature.move(pnt);
  var pnt =  this.newPnt(coords[coords.length-1].lat, coords[coords.length-1].lon)
 this.markerLayer.destroyFeatures();
 this.carFeature = new OpenLayers.Feature.Vector(pnt, null, this.carStyle);

	this.markerLayer.addFeatures([this.carFeature]);
	this.markerLayer.redraw();

	return geometry.getGeodesicLength(new OpenLayers.Projection("EPSG:900913"))/1000;


}

OLMap.prototype.clear = function()
{
	this.markerLayer.destroyFeatures();
	this.pathLayer.destroyFeatures();
}
