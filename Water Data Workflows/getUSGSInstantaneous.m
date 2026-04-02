
function T = getUSGSInstantaneous(stateCd, siteType, startDT, endDT, paramCode)
% getUSGSInstantaneous Retrieve USGS instantaneous values and site attributes.
% T = getUSGSInstantaneous(stateCd, siteType, startDT, endDT)
% T = getUSGSInstantaneous(..., 'ParameterCodes', codes)
% T = getUSGSInstantaneous(..., 'Params', {'pH','temperature',...})
%
% Outputs:
%  T - table with one row per site and columns:
%      siteId, siteName, latitude, longitude, and one column per requested parameter.
%
% Default parameter name -> USGS parameter code map (verify codes for your needs):
%  pH              -> '00400'
%  temperature     -> '00010'  (water temperature)
%  specCond        -> '00095'  (specific conductance)
%  totalNitrogen   -> '00600'  (example; verify if you need a different TN code)
%  sodium          -> '00930'
%  calcium         -> '00940'
%  chloride        -> '00945'
%  phosphorus      -> '00665'  (total phosphorus / orthophosphate; verify)
%
% Notes:
% - You can pass 'ParameterCodes' as a cell array of USGS parameter code strings.
% - The function returns the most recent observed value present in the retrieved time
%   series for the interval. Missing values are NaN.
end


%[appendix]{"version":"1.0"}
%---
%[metadata:styles]
%   data: {"heading1":{"color":"#268cdd","fontFamily":"Trebuchet MS"},"heading2":{"bold":true,"color":"#edb120","fontFamily":"Trebuchet MS","italic":false,"underline":false},"heading3":{"bold":true,"color":"#ffffff","fontFamily":"Trebuchet MS","italic":false,"underline":false},"referenceBackgroundColor":"#333333","title":{"color":"#f57729"}}
%---
