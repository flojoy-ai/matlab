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

% Creating, storing and loading example dataset.

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Matrix";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(data, dc_type);

% Load the example dataset from the cloud.
cloud.fetch_dc(dc_id)

%% 

% Using a measurement folder.

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Matrix";

% Create a measurement folder in the cloud with the name specified.
meas_id = cloud.create_measurement('default');

% Store a datacontainer in the created measurement folder.
cloud.store_in_measurement(data, dc_type, meas_id);

% Fetch a measurement folder in the cloud with the id specified.
measurement = cloud.fetch_measurement(meas_id);
disp(measurement)

%% 

% Listing multiple measurements and DataContainers

% List 10 (unless there's less) DataContainers stored in the cloud.
dc_list = cloud.list_dcs(10);
disp(dc_list)

% List the number of measurements specified.
meas_list = cloud.list_measurement(10);
disp(meas_list)

%% 

% The next sections are for testing all the DataContainer types.

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Grayscale";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(data, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc)

%% 

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Matrix";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(data, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc)

%% 

% Simple example dataset to save.
op.x = linspace(0,2*pi);
op.y = sin(op.x);
dc_type = "OrderedPair";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(op, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc)

%% 

% Simple example dataset to save.
op.x = linspace(0,2*pi);
op.y = sin(op.x);
op.z = sin(op.x);
dc_type = "OrderedTriple";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(op, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc)

%% 

% Example image.
image = imread('ngc6543a.jpg');
dc_type = "Image";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(image, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc);
size(dc)

%% 

% Simple example dataset to save.
sca = 2.1;
dc_type = "Scalar";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(sca, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc)

%% 

% Simple example dataset to save.
vec = [1, 2, 3, 4];
dc_type = "Vector";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(vec, dc_type);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc)
