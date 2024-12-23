#!/bin/bash

# Función para realizar la solicitud a Calypso AI
send_calypso_request() {
    local prompt="$1"
    local CAI_TOKEN="MDE5MzZhNjctNTM0Ny03MDE2LWE1OWItZDhkM2JkYTJiNjU2/Cb1tePmMHS7y0vkCjMpi6Fw4gHm6ihdkPqHCQ3YCuNpMFWqDQpYhjWm2xMviau70C27hoBLoxKjA2dHfvLSA"

    # Realizar la solicitud usando curl
    response=$(curl -s https://www.us1.calypsoai.app/backend/v1/prompts \
        -X POST \
        -H "Authorization: Bearer ${CAI_TOKEN}" \
        -H 'Content-Type: application/json' \
        --data-raw "{\"input\": \"$prompt\"}")

    # Extraer solo la respuesta usando jq
    echo "$response" | jq -r '.result.response'

    # Incluir en logs
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Prompt: $1" >> ./Logs/logs.log
    echo "$response" | jq -r '.result.response' >> ./Logs/logs.log
}

main(){
  if  ! command -v jq &> /dev/null; then
    echo "Error: jq no esta instalado"
    exit 1
  fi
}

while true; do
  #Ingreso de la pregunta
  echo -e "\033[1;34mHola soy Leon, tu asistente para temas de Desarrollo, Scripting y Commandos Linux\nIntroduce tu consulta para Calypso AI (Anthropic)? (o 'salir' para terminar)\033[0m"
  read -r user_prompt
  
  #Verificar si el usuario quiere salir
  if [[ "$user_prompt" == "salir" ]]; then
    break
  fi



  #llama a la funcion y escribe la respuesta
  echo -e "\033[1;32mRespuesta:\033[0m"
  send_calypso_request "Eres un experto en desarrollo de sistemas, tales como Javascript, nodejs, google app script (GAS), HTML, CSS, Bootstrap, scripting en Bash, powershell, entre otros. Tambien tienes expertis es sistemas operativos linux, en particular en Archlinux. Segun tu expertis, necesito que respondas paso a paso y con ejemplos a la siguiente pregunta $user_prompt"

done

# Control de Ejecucion
main
