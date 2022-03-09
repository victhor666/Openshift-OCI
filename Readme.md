<h1>Proyecto para desplegar clusters de openshift en OCI</h1>

El siguiente proyecto desplegará la infraestructura necesaria en OCI para poder poner un cluster de openshift.
Como de momento no está automatizado, hay que hacerlo desplegando máquinas y automatizando la instalación.
La arquitectura es la siguiente:

![esquema](/esquema.png)


Varios pasos a completar para replicar esta infraestructura

<h3>Generación de claves para que terraform acceda a OCI</h3>

    > ssh-keygen -P "" -C "Usuario para Acceso a OCI" -t rsa -b 2048 -m pem -f ~/clavedeoci

<p>Esto generará un fichero de clave pem con ese nombre en el home del usuario, así como la correspondiente clave pública.</p>
<p>Por otro lado, generaremos una clave para acceder a las máquinas linux. Un par de claves ssh. De forma muy similar:</p>

    > ssh-keygen -P "" -C "Usuario para Acceso servidores linux" -t rsa -b 2048 -f ~/linuxuser

La clave publica será algo así, que utilizaremos en nuestros scripts:

<p> ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwDgfXC8dEjv6dteMCoQpM+wrxDkWg1MkXE0TxDsoEnf/tGJh/TTHMZoyXZuPBXLeFUesTCLYsO/gFrNzN0uTjv5V972KiOnfA7hm2XsU/pOw1FkPShfLTociJPR69eGX4E9kywSwUiRg+SsSTKFwNP4zMWXuCCljjtdanJKgPYUgEG/YUstamsFePQo0WvIrXlrP6fXzL+IN0KTqv6/8FW4BKFV3k0iI6f7xIX+9e86K/dYdjW9GqPUXX2WojoqDYCkh7D/bj73+OyzGGNKpOg2iywAqcA6QaxDC6FhhslRcigZnveC1U697gHlmfFJVtL7FeG5IA4iDjD3F6AXgJ Usuario para Acceso servidores linux </p>

