function output = ge_cylinder(X,Y,radius,height,varargin)
% Reference page in help browser: 
% 
% <a href="matlab:web(fullfile(ge_root,'html','ge_cylinder.html'),'-helpbrowser')">link</a> to html documentation
% <a href="matlab:web(fullfile(ge_root,'html','license.html'),'-helpbrowser')">show license statement</a> 
%


AuthorizedOptions = externalCode.googleearth.authoptions( mfilename );

%%%% Assign default parameter values, part of which will
%%%% be overwritten later on during the parsing of parameters:
         id = 'cylinder';
      idTag = 'id';
       name = 'ge_cylinder';
description = '';
    timeStamp = ' ';
timeSpanStart = ' ';
 timeSpanStop = ' ';
 visibility = 1;
  lineColor = 'ffffffff';
  polyColor = 'ffffffff';
  lineWidth = 1.0;
    snippet = ' ';
   divisions = 8;
 altitudeMode = 'relativeToGround';   
    region = ' ';
                 
externalCode.googleearth.parsepairs %script that parses Parameter/value pairs.
                            
if( isempty( Y ) || isempty( X ) || isempty( radius ) || isempty( height ))
    error('empty coordinates passed to ge_cylinder(...).');
end

if ~(isequal(altitudeMode,'clampToGround')||...
   isequal(altitudeMode,'relativeToGround')||...
   isequal(altitudeMode,'absolute'))

    error(['Variable ',39,'altitudeMode',39, ' should be one of ' ,39,'clampToGround',39,', ',10,39,'relativeToGround',39,', or ',39,'absolute',39,'.' ])
    
end 
if region == ' '
	region_chars = '';
else
	region_chars = [ region, 10 ];
end


id_chars = [ idTag '="' id '"' ];
poly_id_chars = [ idTag '="poly_' id '"' ];
name_chars = [ '<name>',10, name,10, '</name>',10 ];
description_chars = [ '<description>',10,'<![CDATA[' description ']]>',10,'</description>',10 ];
visibility_chars = [ '<visibility>',10,int2str(visibility),10,'</visibility>',10 ];
lineColor_chars = [ '<color>',10, lineColor([1,2,7,8,5,6,3,4]),10, '</color>',10 ];
polyColor_chars = [ '<color>',10, polyColor([1,2,7,8,5,6,3,4]) ,10,'</color>',10 ];
lineWidth_chars= [ '<width>',10, num2str(lineWidth, '%.2f') ,10,'</width>',10 ];
altitudeMode_chars = [ '<altitudeMode>',10, altitudeMode,10, '</altitudeMode>',10 ];

if snippet == ' '
    snippet_chars = '';
else
    snippet_chars = [ '<Snippet>' snippet '</Snippet>',10 ];    
end

if timeStamp == ' '
    timeStamp_chars = '';
else
    timeStamp_chars = [ '<TimeStamp><when>' timeStamp '</when></TimeStamp>',10 ];
end

if timeSpanStart == ' '
    timeSpan_chars = '';
else
    if timeSpanStop == ' ' 
        timeSpan_chars = [ '<TimeSpan><begin>' timeSpanStart '</begin></TimeSpan>',10 ];
    else
        timeSpan_chars = [ '<TimeSpan><begin>' timeSpanStart '</begin><end>' timeSpanStop '</end></TimeSpan>',10 ];    
    end
        
end



altitude = height;
radius = convert2degree(radius);
divisions = 2 .^ divisions;
angle_division = 360.0 / divisions;

header=['<Placemark ',id_chars,'>',10,...
    name_chars,10,...
    timeStamp_chars,...
    timeSpan_chars,...
    visibility_chars,10,...
    snippet_chars, ...
    description_chars,10,...
    region_chars, ...
    '<Style>',10,...
        '<LineStyle>',10,...
            lineColor_chars,10,...
            lineWidth_chars,10,...
        '</LineStyle>',10,...
        '<PolyStyle>',10,...
            polyColor_chars,10,...
        '</PolyStyle>',10,...
    '</Style>',10,...
  '<Polygon ',poly_id_chars,'>',10,...
  '<extrude>1</extrude>',10,...
  altitudeMode_chars,...
    '<outerBoundaryIs>',10,...
      '<LinearRing>',10,...
      '<extrude>1</extrude>',10,...
        '<coordinates>',10,];
		
		coordinates = '';
		for i = divisions:-1:0
		
			angle = angle_division * i;
			[xS, yS] = vectorsplit( angle, radius );

			coordinates = [coordinates, sprintf('%.6f,%.6f,%.6f ', X+xS, Y+yS, altitude)];
		
		end
		
footer=['</coordinates>',10,...
      '</LinearRing>',10,...
    '</outerBoundaryIs>',10,...
  '</Polygon>',10,...
'</Placemark>',10];

output = [ header, coordinates, footer ];


function [output] = convert2degree(in)
%% convert2degree
% helper function that converts to decimal degree coordinates
    output = 180 * in / (6378137.0  * pi);
    
    
function [x, y] = vectorsplit( angle, magnitude )
% Splits the vector at angle & magnitude
  
    alpharad = polygonManipulation.deg2rad(angle); %[rad] 

x = sin( alpharad ) * magnitude;           
y = cos( alpharad ) * magnitude;           
          
    