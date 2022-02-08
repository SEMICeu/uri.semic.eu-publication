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
However due to the key insertion of CIRCLECI into a container (step) this will affect some configuration values.
