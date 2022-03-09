<h1>Proyecto para desplegar clusters de openshift en OCI</h1>

El siguiente proyecto desplegará la infraestructura necesaria en OCI para poder poner un cluster de openshift.
Como de momento no está automatizado, hay que hacerlo desplegando máquinas y automatizando la instalación.
La arquitectura es la siguiente:

![esquema](/esquema.png)


<h2>Varios pasos a completar para replicar esta infraestructura</h2>

<h3>Generación de claves para que terraform acceda a OCI</h3>

    > ssh-keygen -P "" -C "Usuario para Acceso a OCI" -t rsa -b 2048 -m pem -f ~/clavedeoci

<p>Esto generará un fichero de clave pem con ese nombre en el home del usuario, así como la correspondiente clave pública.</p>
<p>Por otro lado, generaremos una clave para acceder a las máquinas linux. Un par de claves ssh. De forma muy similar:</p>

    > ssh-keygen -P "" -C "Usuario para Acceso servidores linux" -t rsa -b 2048 -f ~/linuxuser

La clave publica será algo así, que utilizaremos en nuestros scripts:

`ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwDgfXC8dEjv6dteMCoQpM+wrxDkWg1MkXE0TxDsoEnf/tGJh/TTHMZoyXZuPBXLeFUesTCLYsO/gFrNzN0uTjv5V972KiOnfA7hm2XsU/pOw1FkPShfLTociJPR69eGX4E9kywSwUiRg+SsSTKFwNP4zMWXuCCljjtdanJKgPYUgEG/YUstamsFePQo0WvIrXlrP6fXzL+IN0KTqv6/8FW4BKFV3k0iI6f7xIX+9e86K/dYdjW9GqPUXX2WojoqDYCkh7D/bj73+OyzGGNKpOg2iywAqcA6QaxDC6FhhslRcigZnveC1U697gHlmfFJVtL7FeG5IA4iDjD3F6AXgJ Usuario para Acceso servidores linux`

Ahora ya con las claves creadas podemos proceder al despliegue de la infra. Pero antes, deberemos facilitar la clave pública clavedeoci.pub en el portal de OCI. (Esta acción solo se realiza una vez)

![adduser](/add_oracle_user.png)

Una vez añadido, terraform tendrá los mismos permisos que el usuario asignado. Lo ideal es circunscribir los mismos a las tareas que vaya a realizar, pero no vamos a tratar cuestiones de seguridad aqui. 

Para poder lanzar la infra con terraform, recomendamos un fichero de variables tfvars con este formato:

<p>
*TenancyID="ocid1.tenancy.oc1..aaaaaXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"*
*UserID="ocid1.user.oc1..aaaaaaaaccXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"*
*Region="eu-amsterdam-1"*        -----------> o la region en la que se quiera desplegar
*private_key_path="~/clavedeoci"* ----------->La que acabamos de crear 
*fingerprint="4c:ff:59:64:c7:f3:f8:a7:7f:09:8c:2b:9c"* --> Valor extraído de la consola de oci al insertar la clave publica
*ssh_private_key="~/linuxuser"* -->emplazamiento de las claves de acceso a servidores
*ssh_public_key="~/linuxuserpub"*
</p>

<p3>**IMPORTANTE**- Esta información no debe ser visible y los ficheros privados **NO** deben ser compartidos ni subidos aun repositorio publico.</p3>

Siguiente paso, se pueden personalizar los valores por defecto de los ficheros de variables. Se pueden cambiar las rutas, rangos, nombres...si no, todo se desplegará lo definido en el script.

<h2>Ejecución</h2>

Los pasos son los siguientes:

- cd terraform 
- terraform init 
- Terraform plan
- Terraform apply

<p>Si todo es correcto se desplegará la infraestructura descrita más arriba</p>




