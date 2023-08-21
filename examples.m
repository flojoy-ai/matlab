addpath flojoy

import webread.*
import matlab.net.*
import flojoy.*

% To save your api key paste it in place of <key example> and uncomment 
% the next line. After the key is saved loadflojoyconfig will load the key.

% saveflojoyconfig('key_example')

% Initialize the API and load the api key.
cloud = FlojoyCloud;
cloud.api_key = loadflojoyconfig;

% Uncomment the example sections you want to run. 

%% 

% % Creating, storing and loading example dataset.
% 
% % Simple example dataset to save.
% data = [12 14; 5 12];
% dc_type = "Matrix";
% 
% % Store the example dataset to the cloud.
% dc_id = cloud.store_dc(data, dc_type)
% 
% % Load the example dataset from the cloud.
% cloud.fetch_dc(dc_id)

%% 

% % Using a measurement folder.
% 
% % Simple example dataset to save.
% data = [12 14; 5 12];
% dc_type = "Matrix";
% 
% % Create a measurement folder in the cloud with the name specified.
% meas_id = cloud.create_measurement('default');
% 
% % Store a datacontainer in the created measurement folder.
% cloud.store_in_measurement(data, dc_type, meas_id);
% 
% % Fetch a measurement folder in the cloud with the id specified.
% measurement = cloud.fetch_measurement(meas_id);

%% 

% % Listing multiple measurements and DataContainers
% 
% % List 10 (unless there's less) DataContainers stored in the cloud.
% dc_list = cloud.list_dcs(10);
% 
% % List the number of measurements specified.
% meas_list = cloud.list_measurement(10);

