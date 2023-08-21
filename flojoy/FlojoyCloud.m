classdef FlojoyCloud
    properties
        api_key {mustBeNonzeroLengthText} = '0';
    end

    methods
        function r = fetch_dc(obj, dc_id)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='GET');
            urispec = "https://cloud.flojoy.ai/api/v1/dcs/%s";
            uri = sprintf(urispec,dc_id);
            uri = matlab.net.URI(uri);
            response = verified_webread(uri, options);

            message = "Returning DataContainer of type: %s\n";
            fprintf(message,response.dataContainer.type);
            r = response.dataContainer;
        end

        function r = create_payload(obj, dc, dc_type)
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
                case 'Vector'
                    payload = struct();
                    payload.data.v = dc;
                otherwise
                    error('Unsupported DataContainer type. Check case (e.g. OrderedPair).')
            end
            payload.data.type = dc_type;
            r = jsonencode(payload);
        end

        function r = store_dc(obj, dc, dc_type)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='POST');
            uri = "https://cloud.flojoy.ai/api/v1/dcs";
            uri = matlab.net.URI(uri);
            payload = obj.create_payload(dc, dc_type);
            response = webwrite(uri, payload, options);
            message = "Successfully sent DataContainer with ID: %s\n";
            fprintf(message,response.dc_id);
            r = response.dc_id;
        end

        function r = list_dcs(obj, size)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='GET');
            uri = "https://cloud.flojoy.ai/api/v1/dcs";
            uri = matlab.net.URI(uri);

            try
                response = webread(uri, 'size', size, 'inbox', 'true', options);
                r = response.data;
            catch ME
                switch ME.identifier
                    case 'MATLAB:webservices:HTTP500StatusCodeError'
                        warning('HTTP Error 500: Reducing the number of DataContainers to list may fix this issue.')
                    otherwise
                        rethrow(ME)
                end
            end
        end

        function r = create_measurement(obj, name, privacy)
            if nargin < 3
                privacy = 'private';
            end
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='POST');
            uri = "https://cloud.flojoy.ai/api/v1/measurements";
            uri = matlab.net.URI(uri);
            payload = struct();
            payload.name = name;
            payload.privacy = privacy;
            payload = jsonencode(payload);
            response = webwrite(uri, payload, options);
            r = response.ref;
        end

        function r = list_measurement(obj, size)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='GET');
            uri = "https://cloud.flojoy.ai/api/v1/measurements";
            uri = matlab.net.URI(uri);
            response = webread(uri, 'size', size, options);
            r = response.data;
        end

        function r = fetch_measurement(obj, meas_id)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='GET');
            urispec = "https://cloud.flojoy.ai/api/v1/measurements/%s";
            uri = sprintf(urispec,meas_id);
            uri = matlab.net.URI(uri);
            response = webread(uri, options);
            r = response;
        end

        function r = store_in_measurement(obj, dc, dc_type, meas_id)
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='POST');
            urispec = "https://cloud.flojoy.ai/api/v1/measurements/%s";
            uri = sprintf(urispec,meas_id);
            uri = matlab.net.URI(uri);
            payload = obj.create_payload(dc, dc_type);
            response = webwrite(uri, payload, options);
            % message = "Successfully sent DataContainer with ID: %s\n";
            % fprintf(message,response);
            r = response;
        end
    end
end
