# miss_hit-matlab-styler

A MATLAB Class Wrapper for MISS_HIT (Currently only `mh_style` is supported)

![demo](https://user-images.githubusercontent.com/10386119/143576280-c93c3cdd-1ed1-42e3-ae36-b5b427a332c2.gif)

## Install

- Install the brilliant [MISS_HIT](https://github.com/florianschanda/miss_hit) (Python3 is required).
- Download and save the [MISS_HIT.m](https://github.com/Sec-ant/MISS_HIT-MATLAB-API/blob/main/MISS_HIT.m) file in your [MATLAB search path](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).


## Usage

The usage of this wrapper is rather simple. Please refer to [MISS_HIT](https://github.com/florianschanda/miss_hit) for a detailed documentation regarding the styler.

### Default

Execute `MISS_HIT.mh_style()` or `MISS_HIT.mh_style` in MATLAB command window and the code in the **active editor** will be automatically formatted (but not saved):

```matlab
% in matlab command window
MISS_HIT.mh_style()
% or
MISS_HIT.mh_style
```

[`.miss_hit.cfg`](https://florianschanda.github.io/miss_hit/style_checker.html#:~:text=miss_hit.cfg) or [`.miss_hit`](https://florianschanda.github.io/miss_hit/style_checker.html#:~:text=.miss_hit) is regarded as a valid configuration in your project as described in [Setting up configuration in your project](https://florianschanda.github.io/miss_hit/style_checker.html#:~:text=Setting%20up%20configuration%20in%20your%20project).

### Run with Options

You can pass CLI arguments as a character array to the function:

```matlab
% in matlab command window
MISS_HIT.mh_style('--tab_width 2 --ignore-config --fix')
```

When nothing is passed to the function (in default case), `--fix` is automatically added. To explicitly discard all options, run `MISS_HIT.mh_style('')`.

A detailed list of valid options can be acquired in MATLAB command window:

```matlab
% in matlab command window
MISS_HIT.mh_style('-h')
```

 or in shell:

```shell
# in shell
mh_style -h
```

### Add as Shortcuts

You can add `MISS_HIT.mh_style` to your [favorite commands](https://www.mathworks.com/help/matlab/matlab_env/create-matlab-favorites-to-rerun-commands.html) and pin it on the [quick access tool bar](https://www.mathworks.com/help/matlab/matlab_env/access-frequently-used-features.html). For convenience, I wrote a simple function to do this for you:

```matlab
% in matlab command window
MISS_HIT.add_to_quick_access(@MISS_HIT.mh_style)
```

And then you can format your code by simply clicking the icon on the upright corner in the tool bar or use the keyboard shortcut `alt + 1`.

## Acknowledgement

- [florianschanda](https://github.com/florianschanda)/**[miss_hit](https://github.com/florianschanda/miss_hit)**

