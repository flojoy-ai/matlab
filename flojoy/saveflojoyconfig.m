function saveflojoyconfig(flojoy_api)
    % Save flojoy config info.
    % in ~/.flojoy/.config

    % Create the .flojoy folder
    if ispc
        %     userDir = winqueryreg('HKEY_CURRENT_USER',...
        %         ['Software\Microsoft\Windows\CurrentVersion\' ...
        %          'Explorer\Shell Folders'],'Personal');
        userhome = getenv('appdata');
    else
        % userhome = char(java.lang.System.getProperty('user.home'));
        userhome = userpath; % this is a system defined variable for the users home dir
                             % loading the whole java lib is bloating
        [userhome, ~, ~] = fileparts(userhome);    end

    flojoy_config_file = "%s/.flojoy/cloud_key.txt";
    flojoy_config_file = sprintf(flojoy_config_file,userhome);
    flojoy_config_folder   = fullfile(flojoy_config_file);
    mkdir(flojoy_config_folder);


    fid = fopen(flojoy_config_file, 'w');
    fprintf(fid, flojoy_api);
    fclose(fid);

end