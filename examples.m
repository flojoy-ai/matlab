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

% First you must create a measurement to store data in.
meas_id = cloud.create_measurement('default');

%% 

% Using a measurement folder.

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Matrix";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(data, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
disp(dc)

%% 

% Listing multiple measurements

% List the number of measurements specified.
meas_list = cloud.list_measurement(10);
disp(meas_list)

%% 

% The next sections are for testing all the DataContainer types.

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Grayscale";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(data, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
dc = cloud.to_matlab(dc);
disp(dc)

%% 

% Simple example dataset to save.
data = [12 14; 5 12];
dc_type = "Matrix";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(data, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
dc = cloud.to_matlab(dc);
disp(dc)

%% 

% Simple example dataset to save.
op.x = linspace(0,2*pi);
op.y = sin(op.x);
dc_type = "OrderedPair";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(op, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
dc = cloud.to_matlab(dc);
disp(dc)

%% 

% Simple example dataset to save.
ot.x = linspace(0,2*pi);
ot.y = sin(op.x);
ot.z = sin(op.x);
dc_type = "OrderedTriple";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(ot, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
dc = cloud.to_matlab(dc);
disp(dc)

%% 

% Example image.
image = imread('ngc6543a.jpg');
dc_type = "Image";

% Store the example dataset to the cloud.
dc_id = cloud.store_dc(image, dc_type, meas_id);

% Load the example dataset from the cloud.
dc = cloud.fetch_dc(dc_id);
dc = cloud.to_matlab(dc);
size(dc)

%% 

% Simple example dataset to save.
sca = 2.1;
dc_type = "Scalar";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(sca, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
dc = cloud.to_matlab(dc);
disp(dc)

%% 

% Simple example dataset to save.
vec = [1, 2, 3, 4];
dc_type = "Vector";

% Store a datacontainer in the created measurement folder.
dcid = cloud.store_dc(vec, dc_type, meas_id);

% You can fetch a DataContainer without specifying the measurement ID.
dc = cloud.fetch_dc(dcid);
dc = cloud.to_matlab(dc);
disp(dc)
