function OLMap()
{}

OLMap.prototype.init = function(divName)
{   	OpenLayers.Lang.setCode("ru");
	OpenLayers.IMAGE_RELOAD_ATTEMPTS = 5;

	this.map = new OpenLayers.Map(
    {
        div: divName,
       	projection: new OpenLayers.Projection("EPSG:102100"),
		controls: []
    });

//	this.map.addControl(new OpenLayers.Control.LayerSwitcher());
    this.map.addControl(new OpenLayers.Control.Navigation());

	var mapLayer = new OpenLayers.Layer.OSM();
	this.map.addLayer(mapLayer);

	this.pathLayer = this.createVectorLayer("Путь", "#ff0000", "#550000", 0.1);
    this.map.setCenter(this.newLonLat(65, 95), 3);

  	//this.createVectorLayers();

  	//this.addCustomControls();

  	//this.addLayersMenu();
}

OLMap.prototype.createVectorLayer = function(name, lineColor, fillColor, fillOp)
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
    	strokeWidth: 5
}

OLMap.prototype.drawPath = function(coords)
{	var points = [];
	for(var i in coords)
	{
 		points.push(this.newPnt(coords[i].lat, coords[i].lon));
 	}
	var line = new OpenLayers.Geometry.LineString(points);
	var lineFeature = new OpenLayers.Feature.Vector(line, null, this.pathStyle);
	this.pathLayer.addFeatures([lineFeature]);
	this.map.zoomToExtent(line.getBounds());
	return line.getGeodesicLength(new OpenLayers.Projection("EPSG:900913"))/1000;}

OLMap.prototype.continuePath = function(coords)
{
  	var points = [];
  	var geometry = this.pathLayer.features[0].geometry;
	for(var i in coords) geometry.addPoint(this.newPnt(coords[i].lat, coords[i].lon));
 	this.pathLayer.redraw();
	return geometry.getGeodesicLength(new OpenLayers.Projection("EPSG:900913"))/1000;
}
