This directory contains the base templates used to generate the html representation of the specifications.

The toolchain executes a html generation process by rendering the specification data through a template.
In the thema repository each specification is configured with a template to be executed. 
This template bases itself on a generic template stored here. 
This layering creates the ability to have a common look and feel for all specifications. 

The specification's unique content should be configured in the thema repository, the common style is stored here.
The template language used is [NUNJUNCKS](https://mozilla.github.io/nunjucks/).

## Advanced usage

To execute properly the html generation process, the toolchain creates a directory containing all template files.
The directory content is created as follows:
   - initial content are the template files part of the html generation tool distribution.
   - next the content of this directoy is copied into it. This thus *overwrites* files with the same name.
   - finally the content of the template directory of the thema repository is copied into it. This thus *overwrites* files with the same name.

This allows to experiment in a thema repository with a variant of the generic template files.






