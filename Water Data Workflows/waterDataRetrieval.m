%[text] # USGS Water Data Retrieval via API
%[text] List of available api's: [https://api.waterdata.usgs.gov/](https://api.waterdata.usgs.gov/)
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] 
%%
%[text] ### Access and Read Web Data
% url = "https://api.waterdata.usgs.gov/v1/iv?stateCd=TN&siteType=ST&parameterCd=00065&startDT=2025-01-01T00:00:00Z&endDT=2025-12-31T23:59:59Z&format=json"
%[text] Use the USGS 'iv' (instantaneous values) service base URL.
%[text] [https://waterservices.usgs.gov/docs/instantaneous-values/instantaneous-values-details/](https://waterservices.usgs.gov/docs/instantaneous-values/instantaneous-values-details/) 
base = "https://waterservices.usgs.gov/nwis/iv/";

% Configure weboptions: request JSON and allow longer response time
opts = weboptions( ...
    "ContentType","json", ...      % ask for JSON decoding
    "Timeout", 120);               % increase timeout for large responses

% Request instantaneous-stage (00065) data for sites over a range of dates
data = webread(base, opts, ...
    "stateCd","TN", ... % which state
    "siteType","ST", ...% site type = stream (ST)
    "parameterCd","00065", ... % instantaneous/continuous data
    "startDT","2025-01-01", ...
    "endDT","2025-01-02", ...
    "format","json");

% Extract timeSeries array from full data structure
tsData = data.value.timeSeries;
%%
%[text] ### Analyze One Site over Time
n = 12; % which site
heightData = tsData(n).values.value;

% Convert the strings of numbers to doubles
y = str2double({heightData.value})';

% Parse ISO-8601 timestamps into UTC datetimes
x = datetime({heightData.dateTime},'InputFormat','uuuu-MM-dd''T''HH:mm:ss.sssXXX','TimeZone', 'UTC');

figure
plot(x,y)
ylabel(tsData(n).variable.variableName)
%%
%[text] ### Compare Multiple Sites with Different Timing Intervals
% Extract gauge height and timestamp data for two of the sites
height1 = str2double({tsData(1).values.value.value})';
timestamp1 = datetime({tsData(1).values.value.dateTime},'InputFormat','uuuu-MM-dd''T''HH:mm:ss.sssXXX','TimeZone', 'UTC');

height2 = str2double({tsData(2).values.value.value})';
timestamp2 = datetime({tsData(2).values.value.dateTime},'InputFormat','uuuu-MM-dd''T''HH:mm:ss.sssXXX','TimeZone', 'UTC');
%[text] You can, of course, plot them on the same graph, but what if you wanted to compare the height at a specific time? What if you wanted to find the difference between two gauges at each timestamp? How would you interpolate?
figure
plot(timestamp1, height1,'o')
hold on
plot(timestamp2, height2,'o')

ylabel(tsData(1).variable.variableName)
%[text] 
%%
%[text] ### Retime Timetable Data 
%[text] Put the data from each site into a timetable (this could have been donewhen initially extracting the data as well
site1 = timetable(timestamp1',height1);
site2 = timetable(timestamp2',height2);
%[text] Be sure to check to see if the the sites start measuring at the same time or if one needs to be offset. 
% What's the sample rates of sites1 and 2?
site1.Time(2) - site1.Time(1) % MATLAB autodetects that this is a duration calculation
site2.Time(2) - site2.Time(1) % MATLAB autodetects that this is a duration calculation
% Retime with a Live task
% Retime timetable %[task:4f14]
newTimetable = retime(site2,"regular","spline",TimeStep=minutes(15)) %[task:4f14]
%%
%[text] ### Download and Install Community Tools
%[text] You can download these tools directly from the MATLAB File Exchange, or you can navigate within your MATLAB IDE to Add-Ons. Search for the tools on File Exchange within "Add-Ons" and install directly to MATLAB.
%[text] ![](text:image:0bbe)
%[text] %[text:anchor:TMP_1624] Open examples in [TopoToolbox](https://github.com/TopoToolbox/topotoolbox3)
%[text] Open examples in [Bankfull Mapper](https://www.mathworks.com/matlabcentral/fileexchange/181632-bankfullmapper?s_tid=prof_contriblnk)

%[appendix]{"version":"1.0"}
%---
%[metadata:styles]
%   data: {"heading1":{"color":"#268cdd","fontFamily":"Trebuchet MS"},"heading2":{"bold":true,"color":"#edb120","fontFamily":"Trebuchet MS","italic":false,"underline":false},"heading3":{"bold":true,"color":"#ffffff","fontFamily":"Trebuchet MS","italic":false,"underline":false},"referenceBackgroundColor":"#333333","title":{"color":"#f57729"}}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[task:4f14]
%   data: {"appState":"{\"VersionSavedFrom\":6,\"MinCompatibleVersion\":1,\"TableInputs\":[\"site2\"],\"NewTimesWorkspaceDropdownValue\":\"select variable\",\"NewTimesDropdownItems\":[\"Time step\",\"Sample rate\",\"Times from workspace\"],\"NewTimesDropdownItemsData\":[\"regularTimeStep\",\"regularSampleRate\",\"workspace\"],\"NewTimesDropdownValue\":\"regularTimeStep\",\"BasisTypeDropdownItems\":[\"Union\",\"Intersection\",\"Times within common range\",\"Times from first timetable\",\"Times from last timetable\"],\"BasisTypeDropdownItemsData\":[\"union\",\"intersection\",\"commonrange\",\"first\",\"last\"],\"BasisTypeDropdownValue\":\"union\",\"TimeStepSpinnerValue\":15,\"TimeStepUnitsItems\":[\"Years\",\"Quarters\",\"Months\",\"Weeks\",\"Days\",\"Hours\",\"Minutes\",\"Seconds\",\"Milliseconds\"],\"TimeStepUnitsItemsData\":[\"calyears\",\"calquarters\",\"calmonths\",\"calweeks\",\"caldays\",\"hours\",\"minutes\",\"seconds\",\"milliseconds\"],\"TimeStepUnitsValue\":\"minutes\",\"SampleRateSpinnerValue\":0.56,\"SampleRateUnitsValue\":0.001,\"MethodItems\":[\"Fill with missing\",\"Fill with constant\",\"Fill with previous value\",\"Fill with next value\",\"Fill with nearest value\",\"Linear interpolation\",\"Spline interpolation\",\"Shape-preserving cubic interpolation (PCHIP)\",\"Modified Akima cubic interpolation\",\"Sum\",\"Mean\",\"Product\",\"Minimum\",\"Maximum\",\"Number of values\",\"First value in bin\",\"Last value in bin\",\"Custom function\"],\"MethodItemsData\":[\"fillwithmissing\",\"fillwithconstant\",\"previous\",\"next\",\"nearest\",\"linear\",\"spline\",\"pchip\",\"makima\",\"sum\",\"mean\",\"prod\",\"min\",\"max\",\"count\",\"firstvalue\",\"lastvalue\",\"Custom\"],\"MethodValue\":\"spline\",\"ConstantSpinnerValue\":0,\"AggFcnEditFieldValue\":\"@sum\",\"CustomAggFcnSelectorState\":{\"FcnType\":\"local\",\"LocalValue\":\"select variable\",\"HandleValue\":\"@sum\"},\"OutputTableCheckboxValue\":true,\"InputTablesCheckboxValue\":false,\"NumInputTimetables\":1,\"NumOverrides\":0,\"IsSortedTimes\":true,\"SampleRateByDefault\":false,\"MaxOverrides\":1,\"NumInputTables\":1,\"TableDropDownsValues\":[\"site2\"],\"FillTypeDropdownValue\":\"fillwithmissing\",\"InterpolationTypeDropdownValue\":\"spline\",\"AggFcnDropdownValue\":\"sum\",\"MethodTypeDropdownValue\":\"interp\",\"MethodTypeDropdownItems\":[\"Fill values\",\"Interpolate data\",\"Aggregate data\",\"Use VariableContinuity property\"],\"MethodTypeDropdownItemsData\":[\"fill\",\"interp\",\"aggregate\",\"vc\"],\"FillTypeDropdownItems\":[\"Fill with missing\",\"Fill with constant\",\"Fill with previous value\",\"Fill with next value\",\"Fill with nearest value\"],\"FillTypeDropdownItemsData\":[\"fillwithmissing\",\"fillwithconstant\",\"previous\",\"next\",\"nearest\"],\"AggFcnDropdownItems\":[\"Sum\",\"Mean\",\"Product\",\"Minimum\",\"Maximum\",\"Number of values\",\"First value in bin\",\"Last value in bin\",\"Custom function\"],\"AggFcnDropdownItemsData\":[\"sum\",\"mean\",\"prod\",\"min\",\"max\",\"count\",\"firstvalue\",\"lastvalue\",\"Custom\"]}","autorun":"1","collapsed":"0","outputs":"newTimetable","run":"section","taskClassDefFile":"matlab.internal.dataui.timetableRetimer","uniqueId":"matlab\/RetimeTimetable","variablesMap":"{\"newTimetable\":\"newTimetable\"}","view":"controls-only"}
%---
%[text:image:0bbe]
%   data: {"align":"baseline","height":101,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQUAAABlCAIAAADLd2EoAAAACXBIWXMAAA7EAAAOxAGVKw4bAAATy0lEQVR4nO2dfVRbZZ7Hf+ElVYi8SKLQFij00g2mS4Y3pZUWQmS5Ox1mF8LUbXV07E6Mmmh1R06cPbKTs3F2Bz2zFie0m8k57ugc205Nimdo9bYVUlq6RQMinIbEckFLW4oS5C3QLS1k\/7hJbghJIBAIlufzR8\/tc5+X3819vvf5Pa8woPBXgEAgAAAgJNgGIBCrCEZKSkqwbUAgVguofUAgaJAeEAgapAcEggbpAYGgQXpAIGiQHhAIGqQHBIImpLCwMNg2IBBBw63+o\/YBgaBBekAgaPzWQ1g4M43\/yOIKCwtnLi4hArEyhPkXO5xZ\/sLrO3765OIKO3344Cfvv3Pn9tTikiMQy41\/erhze2rRYgCAv9v7grn1fHfHZ4vOwY+yeP0ANrfA8Mj4Ly\/fuj4SsQIGLIWQsLCI2Acnh7+duXMn2LasLfzTw9JZGTEAAIDtv\/\/ysVvQxaaG2wd\/bwPoX62SYDAYjJDQtIKKLUWPX278S\/dZrW1m2mZzFzZimVhpPQSXbQVCsNlOfvSR5UavlyiM08b1K2qTC6Hh65IfLsn82f7ohBQA4GD8raXi9g9rrnx+avr2rWBZtabwTw+cDckvClOXUh5nQ\/Lg9StLyWGJbCt8bFvhY97uPvf4j1fSGFdCw8If+vunc594zTUwOiGl8KUDhg9+1\/Xx\/0zfuR0s29YO\/ulh8PqV3l5vX1YAgJqamv379\/uIkJq6JDndxWz4UcHXLR93Nx3P3v3K3zy2hwr86tMjbcfeDmPes55fcLXt0+BauBYIsL80rx6Wj7kd6Oce\/\/HfZuVkPrxju6A4KCb5Rdwm3mOVf7x08t0vj6u+rKvd+KPCa1+eBZst4x+e27prX\/uHNUgPK8Dd1H\/w3IF+7+DvgcHY7t1HciWMee8yGOYHW3ft27prX7v2ncuNR7cU\/VNmxUvBtWetcTfpwQNUB\/qLlnPvH\/ovjxFCGCEHj55w\/vfO1M2VMs0XmRUvtX94IFhiiImJGRkZiYyMnJiYCIoBQeQu1wOs4g60G+PfXV303cCyYcOGo0ePymQykiQBICIiYnJycsVKDy5o\/VKQsdlsEfdF3Bt5T1\/r6U+UT3z7VZtbhG+\/aiP+\/Yk+w+lIJvO+e9Yt01xEeHh4ZmYmk8kMCQnh8XgAwOVymUwmk8nMyMhYt27dchS6Crn724fVzL2se0PDQna\/\/I\/4U0UA8Lbs0On\/eDqBl5f5s1cAYOhrY\/uHb98wthSnJql+9SIAvN\/a9nbTuekZm\/VWgKcjsrOzFQqF0Wi0Wq05OTkA8Pzzz+fm5rJYLB6Pp1AoOjs710Irsdb1cF90TFDKXXcv02YDkewnP30Wdwa+onoeAH73zzUn\/q2CERJ6oqpiZ\/LGs6\/S43VP5WQ\/lZP9x4stB5rOMxiMm7cDNiPR1tZmNBp5PN7Q0FB3d\/fk5GRERASGYXFxcUajsa2t7fY8ZYlVhAgDAACyDpep\/SpcrCJKht+qqGpYtPkBw2891NTU1NTU+IjgY4YhWEOxPhgfHQlKubduToWGhV7vuTF4fYizIc4ZPnh9KJodBTN3bDPTDLCxIyOvj45uiI52Rrg+OtpjGbozM3NnZiaA9szMzFit1qGhoW+++QYAbDbbxMQE1Z+2Wq3zpRYoj4mgDsfVACBQKsQAGi\/RpKC213txLcHvpJSjkeEe4wcBv\/Wwf\/9+H9U6NTV13gk7f0u8WznQ8Ns\/vKyRFcjxnxeVS38CAMdrTxB\/bkzjpxxo+O2LBa81vCB5+aO\/FqgO\/TwnW5q\/HQBqm\/\/3z61t\/PXrG16QFKgOBcSMyMjIhISErKysnJyc7u5uAOjr67t8+fKWLVuSkpIGBwdzcnJKSkrMZrPFYhkZ8fj5wGKjyA57m6CvUugDYlhQWOv+ErgNMa3gwrkHEzlv6P6199IV9a\/\/9GzevwDApvTE\/\/yoKnVrMhUhMSZG94unLt0Y+PXJj\/MO\/AEA0h984KN9v9iaEB9AMyYmJlQqFXU9OTlps9kuX75M\/ZuYmDg5ORkaGiqTyQAAx3EveWg6egjRMSW5u8pVCuJaQrQZAMDaUl2hAOUxeW4UQCVBlOt0IBJtBthMEEJD9e4+EcHvwGUaEKsIfkcdiMowcPG7BAqtPI8FANYWw0BerCMm5Z5ZDQF1tJAe4LRxQxBLT92aXF3\/m9rKd7\/p6quu\/83cCFsT4ut\/ua\/yrye6Br6t\/+W+gBsQExMjk8mysrKefvrpiIiIiYmJLVu2UO0Dg8GIiIiYnp4+dOhQb2+vjxkJjRQnFVo5Qch7dLhUAw53CJcC5SYphRVVu8HFX9IA7S+JRXROmChDh+MykKgIoVKgrtJLVPK8AR0u01DCgIEOAIGiJL6lGl+GhgjpYVXwwMa4wWsWHxE2xkRfGx1djqJHRkZGRkZ6e3t5PB6GYRMTE0lJSYmJiQwGAwA4HE5ra+snn3wyPT3tOx+9okIPIK4liFrApWQSB7Aygiiz3yUxgAV9xUmdVAMAoO4gy\/gYACTEW1tqNfYiTokIPgDobwzIy+Qqid7Pjvv8oPmH4BD7QPTpD856u3v6g7NxD8Z+0NbuLcIHbe0PsFgBtCc0NJTFYsXFxW3atCkyMjIkJCQyMnLTpk1xcXEsFis0NHSB+WikOnIzXwwAYDW8hTtZdMXFOKyBG3PaAbUMx\/GODIIgtErhInP2CNJDcBj+bvTwm9rntr96VtvsGn5W2\/zc9lcPv6kd+nb4zUb99hqVtqPTNYK2o3N7jerNRv138w\/7+EF2djaPxzMajSRJpqWlZWVlpaWlkSRJDcJSM3TeEatqxfZLYVI8AIC+b5CVWy72kWaBaDpJTKgUAACAQFGCud6S4tUtkL5DsPRSnKy0v\/TII4989tkybZFjLGbxRfB2nk2O35wcv\/kn5VGd6kQKL2lsaOzFwtfGh62T4\/Y1VOO3bo3fuqU8\/anq\/AVewoNDExOFqkPDN2+OB3oyDgDa29sVCsUXX3wxPT0tEon27dv33nvvabXasLCwrKysS5cu+Uyt0Q1qCYLqBVgNb1VoAEBanXRM7ggkdbhMA\/rGLqm8kiDKdbhUo+kkiTJ7f9pX3mqZLoOQE4QcwNpiICEWXHrYMGao3h3IXgTjmWeeOXv27AJjM5nM119\/\/cknvW6h9r3e++DBg++8887UFDpPwJ3wdeGhISH\/d9NrRV8XFhYS0Am4uTjXKWEYplKpnn322b4+nzV15REqtRKonT2KtUQKCwtd679\/7cPU1NQbb7xx8uRJH994HzMMTCYTicEjt2\/NU9NvLf\/BAs7lGDdu3MBxPCYmODP3PhCX50JX9bLObvjtL01NTS3a4UFi+EFADap6mXpbcYRKbWWufeigR7ccY6yuoPFWxOqmoapiBdc1ofElBIIG6QGBoEF6QCBokB4QCBqkBwSCBukBgaBBekAgaND8w1onbO+7jNgkALhd+1i41H4EoMfrma8vTn9cFSw7Vwbf7YNYRagCsEYxkIhVhB2VxL+UAoXWkZTQKhawKFKo1B5TLn7xpERFeP\/1BAqtBxskKqLWSwqhkrZ+KVbNgRLDQghJ2Ra4YlcpQfWXfLx+zzj2reM4jlcPJ3hNK671rBZrSzWV1vSQ3IucBMpjgVlSL86IJ3viSxYivHkRKrWV6SbndoKGWPmq+07dJfyw+g9u+9YXfSiDvrHLGp8QyHXzcxDzOSbdcRM8VLTkYgRKSe5AncsuYbWsuiVASkPMxs\/+g0RFlFFbMqyGtyqqMBUhHK62r7+lT9FxbiSHMQN11+VwEcc1UFlhBFGy4C3hnvet01aNGap3V2FU6fa96j7XBrs9ToPAdc87fhwAALMvtfdz37qEH9+l0zdAkURaJAS9PaFzFzxpaHFGdRQKVkPLgKe8XL8CdvQ3BuQZGIBeXEvwO3VQJsIAwL532ZnhIo5CWjz0ngT7AQKLWHgnVlEHC\/ha1+2IsyRjveJn+6CW2ZvsuoHccjGodQZIL6K8Cwkf6zllFwPo7D5NV7rcm0ekluF1JPTocNyPeqaR4tVd6XKCoB0tiYrI6HAWJ1UINFJc1wNkHY57FYNYlAem83r3xwF91e5qw5jV8BZObYqHqNwSqMVxvLoF\/NntJVAK403n9QD6xi7nBi6B8pgo3u6wdcQ6qo64Vp47SP1ctfAQ5iEzYVL82DDpFkgOWzlJVL5YGb8Dx3FcR24uUQoBJCJHhisnBooFuKOrHX\/9JYHyGEEQBFGGASdJ4PK+xRkY2akBECRxHFvCAfSKU47dtAFDr6jAcVwHIkoSgoR42Cyi+pnyPBaL46lKOWDlyQmCIAgR2N0Pt8eZw5ihVqEHAP15k9VjBI8Ii9LB1NgAVEKHy4TFgj03AI2uhdrt6fpz6asa7NVeXOvS72\/oG4iK9fBUg31UXmQd9bHUdPSwYjEActi6WbSgAYPlYgXc0eXCL39JoDwmj23AcbV9pxJQRx4cKxIAxucYdCv4NdJIdXyCLwYg\/WmdZ8f08DgBQbAjnRXForY4UsUWCUEPSZ5OTcJio2DuJjSNdNaBdcNjIr4EwOXnFexIh8FGz8U3VFU0UINp8pX0lzzg7o6CQKGVgmkgLxfr0eFScB5x6esNznaG533NOTk52dnZboFtbW2tra0LMdmv9gGLjbJSLbdgR7rjdAdNx2B6kYIf39WoBwDQ9w1iIoczI1CUYD0dGgBy0IplUIFi\/mZ\/ypzF3H3roL8xwMoTLaoJ8vg4S0dQ9BC4Hi1h97UaGk2QK7KrTiyy+0uajh7M0TMWKIUeGzd9VQOJldGjXgKFVp43cMrnJ0CvqMDrSMdvvsJ4c0cBAFh5sR045Y5qHLd1A97e4BxneN6yW1tb29pmnZG+cDHAAtoHTOTcE16H61pK5JUEUQnWHtJ5uoOmc4AoAx1ufz0a143kY4bq3Rqwn5xD5USSPY6U6g6SEPnVn\/awb10tq07Qyl2MlKnBZa+6jy+KxtPjuOx5P74Qk+YgLEoHU63L4+jPm6SVfDFoqtRF2krqSCLS0GKl9KyR6viO7fKGFhI4nvJUy3BSqa0kiEoAABgzVOPen4v+KpO6lT0XlZVnbxTJOtzhjtp79jA2TNVla4vOaZNLF9w6LPRwQJMgIR42Y453C9Djyxl2QtV+qpXwSwzg73kCnqFELF0tR9Ii\/ML3nPTca2\/5CBRaKdTOdUdlavocAHCJI1Bo5ZxTjgEx6tw+9\/ElcM8TFj6+RJ3aP68Y3M4TWPr8g0AppHrSCIQr87ijGIdlHSQBAIRF6VGes1iCMwytra1+tQwUS1u\/JFERZZi1pboiiJ02xCrFozvqcvu4oaRSThByGCPJMS95eHKGl5VA+EuIHzKB8pd+oATcX0L8sLENL\/TQsZmvLy6rJasBtN57rXPnMH2Gvuvn39v13Q1qHxAIGqQHBIIG6QGBoAlY\/2GJ60YQiNVAwPTgOklOgcSwCNBnJbgE0l9yXUqFXuHiWOJyNMQSCfB4q\/PNoVe4aJayHA2xRAI\/\/4De39JBn5VggebjVilICUEBjbciEDRIDwgEDdIDAkGD9IBA0CA9IBA0SA8IBA3SAwJBg\/SAQNAgPSAQNEgPCAQN0gMCQYP0gEDQoPV87nB3SQo22q\/7z6nrTdxSSQGcU9ebnBH2sD8\/0swulaR2q0+anelKJWnd6u60veyLh5stwC2VFKyn7owbdYebLdR1eqlkpz0YrjXZk3Py95QnXj1+pHmQusHO37vNcrjeDO5FAwD70T2i5Ku6w80WTv6ecl6USxHsXZICaKJNSi\/dc\/\/FI99vo0sEAOhvUtebAeEZpIe5jBnpqgkAANf6YWcp1zS7Gpm6+3emccFsD0xPY126aAZ2mjOCQwbcXZLiR81HLlggvVSyE5rUaioJd5dEsguo6mu9Zk0szmc7ZUNnMsZK5YLJWTKbm+xytuM1l9oPwIb+figoTTe76gdM9WoTAHBL7UJF+AL5Swsgerj7EqtgF3d2qLn72vq0dPt\/uKmsq5c9VzZzb39UDBuAnZ+5vv8cLSrzSZ0xOjOfAwDAgu72UV7xo2z3xKPt7WCPAwCQvi3xirHfq6Gs4V4ja2cp12sExDwgPcwlilcukUgkEskeZ0W0XDhjjC4oTZ8Vz9zbvz6VCwDAyc+MvmoedM+Igpu6vr\/XDMCOva+\/2\/XLDRbLaFSsQwLmk03WrcX5bufdR7MtvVbew1QNZ+dnQvsFF9VtLKAMlTi1amk+40G6iIWC\/KW5zPGXAAAszWeMe4rz2aZmOszhMlm2JMKVM+6tw308kYQH9k7IQso1159LkzzMbT45OyfTRWPmNi6YzRxu4mh3MwDtks32l+yGXjhj3FuczzE3A8JvUPuwYAabz1xJnO3SUC4Tm5sMHpylcaNOrVaf61+fmc8GALAMj7PYsz7\/bHb02LBrOlN9E7i3QgAW8xVW5qNs7sOJVz9fSE\/Y0nzmamJx\/hzfCzE\/SA9+YLlw5mpycWY0HWLu7V+fWZwIXp0lMNXr7CqyNLdbeeW0c8\/dJeKNtrs1ROaTTbCzONG93HZrcrEPl8wdSrqZgfsbYGsG5C\/NJYpXLuEBAMDYJd2RC663LM1nru4pd6mupu7+nQWsS2Yf4zaWC2eu7hWVfq+uN9WroVQikRQ4MldfmJvOXH8uTbLTPfDilcxt388ZHdpY4Misv0ld715osshNV4h5QX\/\/AbGmQX\/\/AYHwCtIDAkHDSElJCbYNCMRqAbUPCAQN0gMCQRNWWFgYbBsQiNUC4\/777w+2DQjEagH5SwgEDdIDAkHz\/0PJDOaEz8s4AAAAAElFTkSuQmCC","width":261}
%---
