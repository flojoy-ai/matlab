function saveflojoyconfig(flojoy_api)
    % Save flojoy config info.
    % in ~/.flojoy/.config

    % Create the .flojoy folder
    if ispc
        userhome = getenv('appdata');
    else
        userhome = char(java.lang.System.getProperty('user.home'));
    end

    flojoy_config_file = "%s/.flojoy/cloud_key.txt";
    flojoy_config_file = sprintf(flojoy_config_file,userhome);
    flojoy_config_folder = fullfile(flojoy_config_file);
    mkdir(flojoy_config_folder);

    fid = fopen(flojoy_config_file, 'w');
    fprintf(fid, flojoy_api);
    fclose(fid);
end