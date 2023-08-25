classdef FlojoyCloud
    properties
        api_key {mustBeNonzeroLengthText} = '0';
    end

    methods
        function r = fetch_dc(obj, dc_id)
            % Fetch a datacontainer from the cloud.
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='GET');
            urispec = "https://cloud.flojoy.ai/api/v1/dcs/%s";
            uri = sprintf(urispec,dc_id);
            uri = matlab.net.URI(uri);
            response = webread(uri, options);

            message = "Returning DataContainer of type: %s\n";
            fprintf(message,response.dataContainer.type);
            r = response.dataContainer;
        end

        function r = create_payload(obj, dc, dc_type)
            % Ready a DataContainer for storage from matlab data.
            payload = struct();
            payload.data.type = dc_type;
            switch dc_type
                case {'Matrix','DataFrame','Grayscale'}
                    payload.data.m = dc;
                case 'OrderedPair'
                    assert(isstruct(dc), 'DataContainer should be class "structure"')
                    assert(isfield(dc, 'x'), 'Field "x" missing from DataContainer')
                    assert(isfield(dc, 'y'), 'Field "y" missing from DataContainer')
                    payload.data.x = dc.x;
                    payload.data.y = dc.y;
                case 'OrderedTriple'
                    assert(isa(dc, "struct"), 'DataContainer should be class "structure"')
                    assert(isfield(dc, 'x'), 'Field "x" missing from DataContainer')
                    assert(isfield(dc, 'y'), 'Field "y" missing from DataContainer')
                    assert(isfield(dc, 'z'), 'Field "z" missing from DataContainer')
                    payload.data.x = dc.x;
                    payload.data.y = dc.y;
                    payload.data.z = dc.z;
                case 'Image'
                    payload.data.r = dc(:,:,1); % Red channel;
                    payload.data.g = dc(:,:,2); % Green channel;
                    payload.data.b = dc(:,:,3); % Blue channel;
                case 'Scalar'
                    if isa(dc,'double')
                        assert(size(dc,1) == 1,'DataContainer is not a single number (float/integer)')
                        assert(size(dc,2) == 1,'DataContainer is not a single number (float/integer)')
                        dc = double(dc);
                    elseif isa(dc,'struct')
                        dc = double(dc.c);
                        assert(size(dc,1) == 1,'DataContainer is not a single number (float/integer)')
                        assert(size(dc,2) == 1,'DataContainer is not a single number (float/integer)')
                    end
                    payload.data.c = dc;
                case 'Vector'
                    payload.data.v = dc;
                otherwise
                    error('Unsupported DataContainer type. Check case (e.g. OrderedPair).')
            end
            r = jsonencode(payload);
        end

        function r = to_matlab(obj, dc)
            % Deserialize data into matlab types
            dc_type = dc.type;
            switch dc_type
                case {'Matrix','Grayscale'}
                    assert(isfield(dc, 'm'), 'Field "m" missing from DataContainer')
                    dc = dc.m;
                    assert(isa(dc,'double'),'DC is not type double.')
                case 'DataFrame'
                    assert(isfield(dc, m), 'Field "m" missing from DataContainer')
                    dc = dc.m;
                case 'OrderedPair'
                    assert(isfield(dc, 'x'), 'Field "x" missing from DataContainer')
                    assert(isfield(dc, 'y'), 'Field "y" missing from DataContainer')
                    data.x = dc.x;
                    data.y = dc.y;
                    dc = data;
                case 'OrderedTriple'
                    assert(isfield(dc, 'x'), 'Field "x" missing from DataContainer')
                    assert(isfield(dc, 'y'), 'Field "y" missing from DataContainer')
                    assert(isfield(dc, 'z'), 'Field "y" missing from DataContainer')
                    data.x = dc.x;
                    data.y = dc.y;
                    data.z = dc.z;
                    dc = data;
                case 'Image'
                    assert(isfield(dc, 'r'), 'Field "r" missing from DataContainer')
                    assert(isfield(dc, 'g'), 'Field "g" missing from DataContainer')
                    assert(isfield(dc, 'b'), 'Field "b" missing from DataContainer')
                    dc = uint8(cat(3,dc.r,dc.g,dc.b));
                case 'Scalar'
                    dc = double(dc.c);
                    assert(size(dc,1) == 1,'DataContainer is not a single number (float/integer)')
                    assert(size(dc,2) == 1,'DataContainer is not a single number (float/integer)')
                case 'Vector'
                    dc = dc.v;
                    assert(size(dc,2) == 1,'DataContainer is not 1-dimensional (vector)')
                otherwise
                    error('Unsupported DataContainer type. Check case (e.g. OrderedPair).')
            end
            r = dc;
        end

        function r = create_measurement(obj, name, privacy)
            % Create a measurement 'folder' to store DataContainers in.
            % Measurement privacy can be set to private or public.
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
            % List the number of measurements specified.
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
            % Fetch the measurement with the ID specified.
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

        function r = rename_measurement(obj, meas_id, name)
            % Rename the specified measurement.
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, RequestMethod='PATCH');
            urispec = "https://cloud.flojoy.ai/api/v1/measurements/%s";
            uri = sprintf(urispec,meas_id);
            uri = matlab.net.URI(uri);
            payload = struct();
            payload.name = char(name);
            response = webwrite(uri, payload, options);
            r = response;
        end

        function r = store_dc(obj, dc, dc_type, meas_id)
            % Store a DataContainer in the cloud in a measurement.
            import webread.*
            import matlab.net.*
            headers = {'api_key' obj.api_key};
            options = weboptions('HeaderFields', headers, 'Timeout', 30, RequestMethod='POST');
            urispec = "https://cloud.flojoy.ai/api/v1/dcs/add/%s";
            uri = sprintf(urispec,meas_id);
            uri = matlab.net.URI(uri);
            payload = obj.create_payload(dc, dc_type);
            response = webwrite(uri, payload, options);
            message = "Successfully sent DataContainer with ID: %s\n";
            fprintf(message,response.ref);
            r = response.ref;
        end
    end
end
