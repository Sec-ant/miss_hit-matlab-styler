classdef MISS_HIT
    % MISS_HIT A MATLAB Class Wrapper for MISS_HIT
    %
    %   (c) Copyright 2021 Ze-Zheng Wu

    methods (Static, Access = public)

        function mh_style(varargin)

            % platform specifics
            if ismac
                suppress_output = '1> /dev/null 2> /dev/null';
                set_environment = 'export PYTHONIOENCODING=UTF-8 && ';
                [~,username]=system('id -un');
                setenv('PATH', getenv('PATH')+":/Users/"+username(1:end-1)+"/.local/bin/")
            elseif isunix
                suppress_output = '1> /dev/null 2> /dev/null';
                set_environment = 'export PYTHONIOENCODING=UTF-8 && ';
            elseif ispc
                suppress_output = '1> nul 2> nul';
                set_environment = 'set PYTHONIOENCODING=UTF-8 && ';
            else
                throw(MException('MISS_HIT:unsupportedPlatform', ...
                                 'Platform not supported.'));
            end

            % default options
            default_args = {['--fix ', suppress_output]};
%             default_args = {['--fix ']};
            default_args(1:nargin) = varargin;

            % get active editor content
            active_editor = matlab.desktop.editor.getActive;
            active_editor_content = active_editor.Text;
            active_editor_select_row = active_editor.Selection(1);

            % generate a temp file name
            file_name = sprintf('%s.m', tempname(pwd));

            % bind cleanup function (delete temp file) to cleaner
            cleaner = onCleanup(@() MISS_HIT.clean_up_file(file_name));

            % write content to temp file
            file_id = fopen(file_name, 'w');
            fprintf(file_id, '%s', active_editor_content);
            fclose(file_id);

            % format temp file
            format_result = sprintf([set_environment, ...
                                     'mh_style "%s" %s'], ...
                                    file_name, default_args{1});
            system(format_result);

            % replace newline characters
            formatted_content = replace(fileread(file_name), ...
                                        [char(13), newline], ...
                                        newline);

            % write formatted content to active editor
            if ~strcmp(formatted_content, active_editor_content)
                active_editor.Text = formatted_content;
                active_editor ...
                    .goToPositionInLine(active_editor_select_row, 0);
            end

        end

        function add_to_quick_access(function_handle)

            % get function name
            full_function_name = char(function_handle);
            split_function_name = split(full_function_name, '.');
            function_name = split_function_name{end};
            fc = com.mathworks.mlwidgets. ...
                favoritecommands.FavoriteCommands.getInstance();

            % new command instance
            newFavoriteCommand = com.mathworks.mlwidgets. ...
                favoritecommands.FavoriteCommandProperties();

            % set command label
            newFavoriteCommand.setLabel(function_name);

            % construct icon file path
            icon_name = 'icon.png';
            icon_dir = fileparts(mfilename('fullpath'));
            icon_path = fullfile(icon_dir, icon_name);

            % write binary to icon file path
            MISS_HIT.gen_icon(icon_path);

            % set command icon name
            newFavoriteCommand.setIconName(icon_name);

            % set command icon path
            newFavoriteCommand.setIconPath(icon_dir);

            % set command category
            newFavoriteCommand.setCategoryLabel('MISS_HIT');

            % set command code
            newFavoriteCommand.setCode(full_function_name);

            % set command toolbar visibility
            newFavoriteCommand.setIsOnQuickToolBar(true);

            % set command label visibility
            newFavoriteCommand.setIsShowingLabelOnToolBar(true);

            % test if command already exists
            if fc.hasCommand(function_name, 'MISS_HIT')
                fc.removeCommand(function_name, 'MISS_HIT');
            end

            % add command to favorite
            fc.addCommand(newFavoriteCommand);
        end

    end

    methods (Static, Access = protected)

        function clean_up_file(file_name)
            if exist(file_name, 'file') == 2
                delete(file_name);
            end
        end

        function gen_icon(file_name)

            % parse icon data
            icon_base64 = ['iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAY', ...
                           'AAAAf8/9hAAAB00lEQVQ4jaWTv0sbYRjHP3', ...
                           'fJYMkgQtpGbrEgVfCkXAvFRRAdXJwr2lFxF', ...
                           'f+ALDp0FKcW69jSCrZQOogtWJouLqGgQSMS', ...
                           'SGjxR4fCJTlDYpK3PNdreonvUvpM977Pfb7', ...
                           'Pz9egw5IknQiRBWAc6Au8eWC3QWN9hZWvYa', ...
                           'IlsMTSjW661wyMeYW6Jvz7Z0Mp1IaLu7jKa', ...
                           'qUlEMA7wKgO1NgXF3dSRKLik8gCJ5wE/ZP9', ...
                           'VH5WSK+n2zBnziF2M0buY46z9NlowCxEpeY', ...
                           'gbayHFhNPJlBNxcn2CcVvRR+O3Y4x9WwKM2', ...
                           'pSLVVFQMqZT5J8akrDOms2TAN72m6dhx4N+', ...
                           'XDYhBHWDLrdZt4PD3v2r8DwzDDli7KuF+Nm', ...
                           'aFQtO9w6pNfpJT4Yp+dOD9aIxdGbI51An6m', ...
                           '7zbzK0Gw0/SzsGRvVUGQ2M9pxRIMluRu+LJ', ...
                           '2WyH/K+7XXK3VyH3J4F56Oz0sGuzrP/ot94', ...
                           'gNxEvcSHLw80EYX1pT1lA3r9GTfZrm6vKLm', ...
                           '1ci+y14jhRE2kiJ1PsaYBTwQR/F7kUKqQNW', ...
                           't+t/H74//zJ1auUbhc8EvEdhYZvn5f69yRE', ...
                           '577NUdnNdddN0yMO6HH1ln2hLZxX3c9pjC9', ...
                           'k/PGfgFpAK+orcweRAAAAAASUVORK5CYII='];
            icon_binary = matlab.net.base64decode(icon_base64);

            % write content to temp file
            file_id = fopen(file_name, 'w');
            fwrite(file_id, icon_binary);
            fclose(file_id);
        end

    end
end