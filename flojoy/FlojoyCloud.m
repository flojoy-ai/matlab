classdef FlojoyCloud
    properties
        api_key {mustBeNonzeroLengthText} = '0'
    end


    methods (Access = private)
        function verify_responsecode(httpCode)
            switch httpCode
                case 200
                    return;
                case 400
                    warning('HTTP Bad Request (400)');
                case 401
                    warning('HTTP Unauthorized (401)');
                case 403
                    warning('HTTP Forbidden (403)');
                case 404
                    warning('HTTP Not Found (404)');
                case 500
                    warning('HTTP Internal Server Error (500)');
                otherwise
                    warning(['HTTP Response Code: ', num2str(httpCode)]);
            end
        end

        function response = verified_webread(uri, options)
            try
                response = webread(uri, options);
                verify_responsecode(response.StatusCode);
            catch ME
                error(['Error reading from the Flojoy API: ', ME.message]);
            end
        end
        
        function response = verified_webwrite(uri, payload, options)
            try
                response = webwrite(uri, payload, options);
                verify_responsecode(response.StatusCode);
            catch ME
                error(['Error writing to the Flojoy API: ', ME.message]);
            end
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
            response = verified_webread(uri, options);

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
            response = verified_webwrite(uri, payload, options);
            message = "Successfully sent DataContainer with ID: %s\n";
            fprintf(message,response.dc_id);
            r = response.dc_id;
        end
    end
end
