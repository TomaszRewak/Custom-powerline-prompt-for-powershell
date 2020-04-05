# Custom powerline prompt for powershell

![Example](https://raw.githubusercontent.com/TomaszRewak/Custom-powerline-powershell-prompt/master/About/Example.png)

It's a simple script containing few useful utils that help in creating custom, pretty and fully flexible Powershell prompts.
If you don’t want to write too much code yourself, I would recommend you using one of the existing solutions that work out of the box ([for example this one](https://www.hanselman.com/blog/HowToMakeAPrettyPromptInWindowsTerminalWithPowerlineNerdFontsCascadiaCodeWSLAndOhmyposh.aspx)).

But if you want to create a fully custom and tailor made prompt, feel free to fork this repo and adjust it to your needs.

### How to set it up

1.	Get yourself a modern terminal ([for example the Windows Terminal](https://github.com/microsoft/terminal)).
2.	Install a font the supports powerline characters ([for example the CascadiaMonoPL.ttf](https://github.com/microsoft/cascadia-code/releases)) and set it as the default font of your terminal.
3.	Open (or create) your Powershell profile file ([on how to do it](https://www.howtogeek.com/50236/customizing-your-powershell-profile/)).
4.	Paste the content of the [profile.ps1](https://github.com/TomaszRewak/Custom-powerline-prompt-for-powershell/blob/master/profile.ps1) script at the end of your profile file.
5.	Customize the behavior of the script based on your personal needs.

### Customization

The `profile.ps1` script defines two useful classes: `Color` and `PromptBuilder`. Everything after that is me using those classes to customize my own prompt. The customization code contains few hardcoded paths from my environment, so you will definitely want to rewrite it. Nevertheless, it can be a good starting point for experimentations and a nice learning example on how to use this script.

The idea here is simple:
1.	Create an instance of the `PromptBuilder` class.
2.	Call the `WithSection` method to append new a block at the end of the prompt. The `WriteSection` method allows you to specify the background color of the new section.
3.	Call the `WithSeparator` method (or the `WithReversedSeparator` depending on the direction the separator is facing) to add the powerline separator between sections. You have to call it between the `WithSection` calls. The foreground and background color of the separator will be derived from neighboring sections.
4.	Get the complete string by calling the `ToString` method of the `PromptBuilder` and return it from the `prompt` function

The list of powerline character codes can be bound [here](https://github.com/ryanoasis/powerline-extra-symbols).

