function gitignore-plugin-files
    set --local fish_plugins $__fish_config_dir/fish_plugins
    set --local plugins (string match --regex -- '^[^\s]+$' <$fish_plugins)

    set --local gitignore_func $__fish_config_dir/functions/.gitignore
    set --local gitignore_comp $__fish_config_dir/completions/.gitignore
    set --local gitignore_conf $__fish_config_dir/conf.d/.gitignore

    # Reset .gitignore_s
    echo -n > $gitignore_func
    echo -n > $gitignore_comp
    echo -n > $gitignore_conf

    # Write plugin's file path to .gitignore
    for plugin in $plugins
        test -e "$plugin" && set plugin (realpath $plugin)
        set --local files_var _fisher_(string escape --style=var -- $plugin)_files
        set --local files $$files_var

        for file in $files
            set file (string replace $__fish_config_dir/ '' $file)
            switch $file
                case 'completions/*'
                    echo (string replace completions/ '' $file) >> $gitignore_comp
                case 'functions/*'
                    echo (string replace functions/ '' $file) >> $gitignore_func
                case 'conf.d/*'
                    echo (string replace conf.d/ '' $file) >> $gitignore_conf
            end
        end
    end
end
