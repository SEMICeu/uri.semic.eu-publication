# supporting private repositories

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
- use instead of 'https://github.com/<ORG>/<REPO>' , 'git@Thema-private:<ORG>/<REPO>.git' as  the value of the repository in the configuration of a publication point.

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

## Multi environment configuration

The editors normally are only concerned with the individual publication points of a specification.
