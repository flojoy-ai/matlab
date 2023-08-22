function api_key = loadflojoyconfig()
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

    api_key = char(importdata(flojoy_config_file));
end