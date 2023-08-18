import webread.*
import matlab.net.*
import flojoy.*

% saveflojoyconfig('key_example')

data = [12 14; 5 12];
dc_type = "Matrix";


% FlojoyCloud.api_key = loadflojoyconfig;
% 
cloud = FlojoyCloud;
cloud.api_key = loadflojoyconfig;

dc_id = cloud.store_dc(data, dc_type);

cloud.fetch_dc(dc_id)

