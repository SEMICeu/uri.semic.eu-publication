# supporting private repositories

# private repository 'Generated'
The repository 'Generated' is the repository in which the toolchain will write the generated artifacts.
If this repository is private, then one should create a deploy key as described in the documentation for github.com.
The private key should be added to circleci config in the additional ssh keys having as hostname "github.com".
The fingerprint of this private key should be placed in the .circleci/config in the create-artifact step configuration.
This will insert that key into the create-artifact step.
The public key should be installed as a deploy key with read/write rights on the 'Generated' repository in github. 

# private repository 'Thema'
When a source repository is private, then a similar approach as for the private repository 'Generated' should be followed.
However due to the key insertion of CIRCLECI into a container (step) the following has to be considered:

- create a new deploy key for the private 'Thema' repository
- enable the public key as deploy key for the 'Thema' repository (read access is sufficient)
- insert the private key in CIRCLECI project as additional ssh key with as (dummy) hostname Thema-private
- enable the update of the ssh configuration for this (dummy) hostname Thema-private
- use instead of 'https://github.com/<ORG>/<REPO>' , 'git@Thema-private:<ORG>/<REPO>.git' as  the value of the repository in the configuration of a publication point.

# background documentation
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
- https://circleci.com/docs/2.0/gh-bb-integration/#best-practices-for-keys
- Where to find in the CIRCLECI webapp the ssh key configuration for a project:
    - login into CIRCLECI
    - select the repository (called project in CIRCLECI webapp)
    - go to project settings (button located on the right top)
    - select the tab ssh settings (in menu on the right)
    - additional ssh key configuration is at the bottom of the page

