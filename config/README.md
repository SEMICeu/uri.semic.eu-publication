# Supporting private repositories

## private repository 'Generated'
The repository 'Generated' is the repository in which the toolchain will write the generated artifacts.
If this repository is private, then one should create a deploy key as described in the documentation for github.com.
The private key should be added to circleci config in the additional ssh keys having as hostname "github.com".
The fingerprint of this private key should be placed in the .circleci/config in the create-artifact step configuration.
This will insert that key into the create-artifact step.
The public key should be installed as a deploy key with read/write rights on the 'Generated' repository in github. 

## private repository 'Thema'
When a source repository is private, then a similar approach as for the private repository 'Generated' should be followed.
However due to the key insertion of CIRCLECI into a container (step) the following has to be considered:

- create a new deploy key for the private 'Thema' repository
- enable the public key as deploy key for the 'Thema' repository (read access is sufficient)
- insert the private key in CIRCLECI project as additional ssh key with as (dummy) hostname Thema-private
- enable the update of the ssh configuration for this (dummy) hostname Thema-private
- use instead of `https://github.com/<ORG>/<REPO>` , `git@Thema-private:<ORG>/<REPO>.git` as  the value of the repository in the configuration of a publication point.

This has to be executed for each private repository.

## background documentation
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
- https://circleci.com/docs/2.0/gh-bb-integration/#best-practices-for-keys
- Where to find in the CIRCLECI webapp the ssh key configuration for a project:
    - login into CIRCLECI
    - select the repository (called project in CIRCLECI webapp)
    - go to project settings (button located on the right top)
    - select the tab ssh settings (in menu on the right)
    - additional ssh key configuration is at the bottom of the page


# Configuration

|File|Purpose|Adaptation expactation|
|----|-------|----------------------|
|config.json|The main configuration of the toolchain. | This should be adapted when deploying a new toolchain instance.|
|config-ap.json| Configuration for the extraction of the data from the UML model, this is for application profiles | Usually the defaults are fine.|
|config-oj.json| Configuration for the extraction of the data from the UML model, this is for tree structured application profiles | Usually the defaults are fine.|
|config-voc.json| Configuration for the extraction of the data from the UML model, this is for vocabularies | Usually the defaults are fine.|
|context| The header added to each generated json-ld context file | Usually the defaults are fine |
|ontology.defaults.json| The configuration of the contact details for the generated RDF files | This should be adapted when deploying a new toolchain instance.|
|trigger.all| dummy file to support editors| |

## config.json

```
{
  "primeLanguage": "en",   -- the prime language in which the specifications are maintained and published
  "otherLanguages": [      -- the other languages for which translation support is activated, can be empty
    "fr", "de"
  ],
  "hostname": "https://dev.specs.org/", -- The hostname of the deployment environment on which the publications in this branch are published
                                        -- usage suggestion: name the branch after the subname in the hostname
  "domain": "data.spec.org",            -- The domain on which the URIs of that are created by this toolchain
                                        -- usually it is the hostname without the deployment environment
                                        -- but it can be any other persistent domain .
  "publicationpoints" : ["dev"],        -- The directories from which the publication points are to be published
                                        -- For a suggested organisation and usage see below in the Editors section.
  "generatedrepository" : {             -- The target repository to which the toolchain will write its generated artifacts
	  "organisation": "SEMICeu",                -- the organisation in github
	  "repository" : "uri.semic.eu-generated",  -- the repository in the organisation
	  "private" : true                          -- whether or not the repository is private.
  },
  "toolchainversion" : "3",             -- The toolchain version that is deployed, only adapt in case of toolchain management
  "toolchain" : {
	  "strickness" : "lazy",            -- the strictness w.r.t. to possible errors occuring during the toolchain execution
                                            -- for now binary options lazy/not-lazy are supported
                                            -- where lazy means try to go as far as possible ignore possible erroneous cases
	  "version": 3                      -- The toolchain version that is deployed, only adapt in case of toolchain management
  }
}
```

# Editoral flow

## Used terminology

A *Thema repository* is a git repository containing all information that is related to a collection of specifications. A Thema repository may contain information about a single document, but usually  it contains several specifications that are managed together (natural goverance). There is no branching strategy imposed by the toolchain on a Thema repository. Consequently the origanisation and structure may differ from one to another. The toolchain, however, imposes the precence of the necessary information for each specification. Although there is a flexible configuration possible, the easiest to have it all setup is to initialize a new Thema repository from https://github.com/Informatievlaanderen/OSLOthema-template.  

A *publication point* refers to a specific state of the specification. This specific state is identified as a commit/branchtag of a Thema repository.

The *publication environment* (this repository) is a description of the publication state for a publication environment. The publication environment will contain a list of publication points describing the specifications that are published. 

The *generated repository* is the repository where the toolchain based on the configuration in the publication environment is writing its results. The generated repository is created in such a way that a proxy with the corresponding hostname can serve the repository as static website. 

The *toolchain* is the complete setup of an ecosystem of data repositories, operational guidelines, and software supporting the publication of the specifications. To have a low level adoption, the whole ecosystem relies on Open Source and free tier resources, except for the UML modeling tool. IT is future work to lift this last dependency. In some explainations the term can mean only the sequence of transformation steps that will create from the list of publication points a new published state in the generated repository.   

A *editor* of a specification is a person updating the content of a specification. This might be changing the semantical data model, but also the surrounding texts such as conformance statements, examples, the list of collaborators and the metadata about the specification. 

A *publication environment maintainer* is the person in charge of the global coherency of the publication environment. For instance that all specifications are correctly published at the right level of quality.

## Happy editorial flow 

The toolchain is setup with the intend to let editors focus on the publication of a specification. From the perspective of an editor, publishing a specification is the management of the set of publications points for a specification. For this the editor, updates the one of files containing publication points. Each commmit to the repository will trigger the processing of the publications points. When no blocking errors are present, a new state is written to the generated repository. Blocking errors can be inspected by reading the error report of the failed step in CIRCLECI, while non-blocking errors are written out to generated repository. 


## Publication points structure and organisation

Publication points are expressed as follows:

```
 {
        "urlref":"/doc/applicatieprofile/<SPECIFICATION>/<VERSION>",
        "repository":"https://github.com/<ORG>/<THEMA_REPOSITORY>",
        "branchtag":"<BRANCHTAG>",
        "name":"<SPECIFICATION_NAME>",
        "filename":"config/<SPECIFICATION>.json",
        "navigation":{
            "prev":"/doc/applicatieprofiel/<SPECIFICATION>/<VERSION>",
            "next":"/doc/applicatieprofiel/<SPECIFICATION>/<VERSION>"
        },
        "type" : "<PUBLICATIONPOINT_TYPE>",
        "disabled" : boolean
    },
```

### publication points fields

- *urlref* : the relative url on which the specification will be published. The absolute url is config.hostname + urlref. This is also the path where the specification is written to on the generated repository.
- *repository* : the thema repository where the specification is stored. A template for the configuration is found in https://github.com/Informatievlaanderen/OSLOthema-template.  For public accessible repositories the http notation is preferred, while for private repositories the ssh notation should be used. 
- *branchtag*: the commit in the thema repository that is used to create the specification of. This is the most important field for an editor as this determines the result of the toolchain. It is intented to be commit hash or tag. This ensures that the generation process for this publication point always has the same content. When it is a commit hash or tag, reapplying the generation process by the toolchain will result in the same output. However, because git does not make a diffference between the command to fetch the content from a branch or commit/tag, the value can also be a branch. In that case regeneration of the  publication point is no guaranteed to result in the same output as a previous run. When the editor has added new information to the branch in the thema repository then the toolchain will fetch the latest content, and thus create a specification based on the latest content. This might be intended behaviour, but when dealing with versioned specification documents, this might be undesirable. To avoid unintended results, the recommendation is to use commit/tags.
- *filename* : the name of the config file in the thema repositorty containing the configuration of the specification that is the subject of this publication point. If omitted the filename defaults to `config/eap-mapping.json`
- *name* :  the name of the spefication in the filename.
- *navigation*: a structure with a next or prev attribute containing a relative URL of a next or previous version of the specification
- *type*: the publication point type. Can be omitted for publication points that describe a document, it is used to create special variants of publication points.
- *disabled*: a boolean indicating if the the publication point should be processed. This is an aid when resolving conflicts between concurrent usage of the toolchain by multiple editors. Suppose one editor creates a publication point that leads to a processing error by the toolchain. It is this editor's responsability to resolve the issue. As long this issue is not resolved the whole toolchain is blocked for all other editors. To provide the editor sufficient time to resolve the issue and to deblock the other editors, the publication point can be disabled. This is a clean git source controlled operation and it can be executed by other editors, to deblock themselves. When the issue is resolved by the editor, the publication point can be reactivated again.


### variant 1 - by copy
This variant of the above publication point sidetracks the generation process from the original content
```
 {
        "urlref":"/doc/applicatieprofile/<SPECIFICATION>/<VERSION>",
        "repository":"https://github.com/<ORG>/<THEMA_REPOSITORY>",
        "branchtag":"<BRANCHTAG>",
        "name":"<SPECIFICATION_NAME>",
        "filename":"config/<SPECIFICATION>.json",
        "navigation":{
            "prev":"/doc/applicatieprofiel/<SPECIFICATION>/<VERSION>",
            "next":"/doc/applicatieprofiel/<SPECIFICATION>/<VERSION>"
        },
        "type" : "raw"
        "disabled" : boolean
    },
```

## Multi environment configuration

## 

# Disaster recovery & operational resources 

The setup of the toolchain is designed to consume minimal amount of operational costs. As all activity is done through source version control, the maintainers of the toolchain the publication environment obtain a very resiliant system. The sole single point of failure is the source control system, in this case github. The generated repository is the history of the publication environment. Loosing access to this repository is not entirely critical as the complete state can be recreated from the publication repository. Similary loosing control of the publication environment is not critical as the generated repository contains the state of the publication environment the form of the result of the transformation process. 

More critical is loosing access to the thema repositories, as these contain the UML documents wich form the basis for the specifications. However with the necessary effort a UML document corresponding to the generated specification can be created.
