%[text] # Water Data Analysis
%[text] 
%[text] Let's get some additional water data now. You can look up the parameter codes to use in the Instantaneous Value Service api ([https://waterdata.usgs.gov/code-dictionary/](https://waterdata.usgs.gov/code-dictionary/)), but for now, let's use some synthetic data.
%[text] 
% load data
data = readtable('SyntheticData.xlsx')
%[text] 
%%
% Plot location on a map. Make one of the columns of the table the color
% data
figure
geoscatter(data.Latitude,data.Longitude,100, data.TDS_mg_L_,'filled')
geobasemap('colorterrain')
colorbar
%%
% basic statistical analysis
summary(data)
%%
% Curve Fitting
curveFitter
%%
% PCA
sc = data.Spec_Cond___S_cm_;

% Select the relevant columns for PCA
dataForPCA = table2array(data(:,[3 5:9 13])); % Replace with actual column names
% Perform PCA on the data
[coeff, score, latent,tsquared,explained] = pca([sc dataForPCA]);

% Visualize the PCA results
figure;
scatter3(score(:, 1), score(:, 2),score(:,3),50, 'filled');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
zlabel('Principal Component 3');
title('PCA Result');
axis equal
ylim([-200 200])
zlim([-200 200])


%%
% Mann–Whitney U test
% Perform the Mann–Whitney U test between two groups in the dataset
group1 = data(1:10, :); % Assuming 'Group' is a column in the data
group2 = data(11:end, :); % Assuming 'Group' is a column in the data
[p, h] = ranksum(group1.Spec_Cond___S_cm_, group2.Spec_Cond___S_cm_);
disp(['P-value: ', num2str(p)]);
disp(['Hypothesis test result: ', num2str(h)]);



%[appendix]{"version":"1.0"}
%---
%[metadata:styles]
%   data: {"heading1":{"color":"#268cdd","fontFamily":"Trebuchet MS"},"heading2":{"bold":true,"color":"#edb120","fontFamily":"Trebuchet MS","italic":false,"underline":false},"heading3":{"bold":true,"color":"#ffffff","fontFamily":"Trebuchet MS","italic":false,"underline":false},"referenceBackgroundColor":"#333333","title":{"color":"#f57729"}}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
