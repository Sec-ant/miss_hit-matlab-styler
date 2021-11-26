% MISS_HIT A Matlab Class API for MISS_HIT
%
%   (c) Copyright 2021 Ze-Zheng Wu

function mh_style(varargin)

    % default options
    default_args = {'--fix'};
    default_args(1:nargin) = varargin;

    % get active editor content
    active_editor = matlab.desktop.editor.getActive;
    active_editor_content = active_editor.Text;
    active_editor_selection_row_num = active_editor.Selection(1);

    % generate a temp file name
    file_name = sprintf("%s.m", tempname(pwd));

    % bind cleanup function to cleaner
    cleaner = onCleanup(@() clean_up_file(file_name));

    % write content to temp file
    file_id = fopen(file_name, 'w');
    fprintf(file_id, "%s", active_editor_content);
    fclose(file_id);

    % format temp file
    format_result = sprintf(['set PYTHONIOENCODING=UTF-8 &&', ...
                             'mh_style "%s" %s'], ...
                            file_name, default_args{1});
    [~, ~] = system(format_result);

    % write formatted content to active editor
    formatted_content = replace(fileread(file_name), ...
                                [char(13), newline], ...
                                newline);
    if ~strcmp(formatted_content, active_editor_content)
        active_editor.Text = formatted_content;
        active_editor ...
         .goToPositionInLine(active_editor_selection_row_num, 0);
    end
end

function clean_up_file(file_name)
    if exist(file_name, 'file') == 2
        delete(file_name);
    end
end
