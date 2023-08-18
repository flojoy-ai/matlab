classdef FlojoyCloud
    properties
        api_key {mustBeNonzeroLengthText} = '0'
    end

    methods
        function r = fetch_dc(obj, dc_id)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key; 'Content-Type' 'application/json'};
            options = weboptions('HeaderFields', headers, RequestMethod='GET');
            urispec = "https://cloud.flojoy.ai/api/v1/dcs/%s";
            uri = sprintf(urispec,dc_id);
            uri = matlab.net.URI(uri);
            response = webread(uri, options);

            message = "Returning DataContainer of type: %s\n";
            fprintf(message,response.dataContainer.type);
            r = response.dataContainer;
        end

        function r = store_dc(obj, dc, dc_type)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key; 'Content-Type' 'application/json'};
            options = weboptions('HeaderFields', headers, RequestMethod='POST');
            uri = "https://cloud.flojoy.ai/api/v1/dcs";
            uri = matlab.net.URI(uri);
            
            switch dc_type
                case {'Matrix','DataFrame','Grayscale'}
                    payload = struct();
                    payload.data.m = dc;
                case 'OrderedPair'
                    payload = struct();
                    payload.data.x = dc.x;
                    payload.data.y = dc.y;
                case 'OrderedTriple'
                    payload = struct();
                    payload.data.x = dc.x;
                    payload.data.y = dc.y;
                    payload.data.z = dc.z;
                case 'Image'
                    payload = struct();
                    payload.data.r = dc(:,:,1); % Red channel;
                    payload.data.g = dc(:,:,2); % Red channel;
                    payload.data.b = dc(:,:,3); % Red channel;
                case 'Scalar'
                    dc = double(dc);
                    assert(size(dc) == 1,'DataContainer is not a single number (float/integer)')
                    payload = struct();
                    payload.data.c = double(dc);
            end

            payload.data.type = dc_type;
            payload = jsonencode(payload);
            response = webwrite(uri, payload, options);
            message = "Successfully sent DataContainer with ID: %s\n";
            fprintf(message,response.dc_id);
            r = response.dc_id;
        end
    end
end
