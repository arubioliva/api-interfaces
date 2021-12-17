#!/bin/bash
# parameter table_names

# Metodo para mostrar el error
print_error(){
    echo "Error: $1"
    exit 1
}

# Plural en inglés para los nombre de las tablas
table_name(){
    if [[ $1 =~ [aeiou]y$ ]]; then
        var="${1}s"
    elif [[ $1 =~ (sh|s|x|z)$ ]]; then
        var=$(echo "$1" | sed -E 's/(sh|s|x|z)$/ies/g')
    elif [[ $1 =~ [^aeiou]y$ ]]; then
        var=$(echo "$1" | sed -E 's/[^aeiou]y$/ties/g')
    elif [[ $1 =~ o$ ]]; then
        var="${1}es"
    elif [[ $1 =~ e$ ]]; then
        var="${1}s"
    else
        var="${1}s"
    fi

    echo $var
}

# Crear archivo
create_file(){
    name="$1"
    names_count=$(echo "$name" | grep -o "_" | wc -l)
    
    if [[ $names_count > 0 ]];then
        table=$(echo "$name" | cut -d "_" -f 1)
        table=$(table_name "${table}")
        table="${table}_`(echo "$name" | cut -d "_" -f 2-)`"
    else
        table=$(table_name "${name}")
    fi

    class=$(capitalize "${name}")
    method=$(echo "$class" | sed -E 's/^(\w)/\L&/g')

    echo -e "<?php\nrequire_once 'controllers/main_controller.php';\n\nclass ${class}Controller extends MainController\n{\n\tpublic function __construct()\n\t{\n\t\t\$this->setTable(\"${table}\");\n\t}\n}" > "./controllers/${name}_controller.php"
    echo -e "<?php\nrequire_once 'controllers/${name}_controller.php';\n\nfunction ${method}ExecRoute()\n{\n\t\$controller = new ${class}Controller();\n\trequire_once 'routes.php';\n\texecRoute(\$controller);\n}" > "./routes/${name}_routes.php"
}

# Capitalizar palabras de un nombre
capitalize(){
    IFS='_' read -ra word <<< "$1"
    for i in "${word[@]}"; do
        table_name+="${i^}"
    done
    echo $table_name
}

# Main
if [[ -d "./controllers" && -d "./routes" ]]; then
    if [[ $* != 0 ]]; then
        for name in $@; do
            create_file "$name"
        done
    else
        print_error "falta el nombre de los elementos a crear."
    fi
else
    print_error "comprueba que te encuentras en la carpeta correcta"
fi

exit 0