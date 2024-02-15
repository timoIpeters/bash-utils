# Bash Utils
This project contains a collection of bash scripts created to simplify specific tasks.

## Interactive CLI Props Generator
A utility script used to create spring boot configurations from user input. The script is designed like an interactive cli tool wehre the user gets several prompts and is guided through the creation process of the properties. If the user needs help with any prompt, the !help command can be executed to get some more information about the current value to be entered.

The provided utility script already comes with preconfigured prompts (p1-p5) that exemplify the creation of all necessary properties to use Spring Data MongoDB. If you want to customize the script for your own use case, just add/remove/adjust the `pX_var`, `pX_help` and `prompt_collections` variables and implement the property generation logic in the `generate_properties()` method. Just make sure that the properties generated in the `generate_properties()` method have to be written into the global variable `generated_properties` for the script to work properly.
