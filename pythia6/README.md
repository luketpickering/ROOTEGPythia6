# Pythia6

Copy of source retrieved from https://pythia.org/download/pythia6/pythia6428.f on 2025/04/08

# ROOT Pythia6 Bindings

Copy of source retrieved from http://root.cern.ch/download/pythia6.tar.gz on 2025/04/08

pythia6_common_address.c modified to remove ODR violations:

```bash
sed -i "s/int /extern int /g" pythia6_common_address.c
sed -i "s/char /extern char /g" pythia6_common_address.c
sed -i "s/extern int pyuppr/int pyuppr/g" pythia6_common_address.c
```