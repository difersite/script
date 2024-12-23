#!/bin/bash

# Función para realizar la solicitud a Calypso AI
send_calypso_request() {
    local prompt="$1"
    local CAI_TOKEN="mi api"

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

    #Respuesta en formato markdown
    echo "$response" | jq -r '.result.response' >> ./respuesta.md
}

main(){
  if  ! command -v jq &> /dev/null; then
    echo "Error: jq no esta instalado"
    exit 1
  fi
}

while true; do
  #Ingreso de la pregunta
  echo -e "\033[1;34mHola soy Pame, tu asistente de escritura\nIntroduce tu consulta para Calypso AI (Anthropic)? (o 'salir' para terminar)\033[0m"
  read -r user_prompt
  
  #Verificar si el usuario quiere salir
  if [[ "$user_prompt" == "salir" ]]; then
    break
  fi



  #llama a la funcion y escribe la respuesta
  echo -e "\033[1;32mRespuesta:\033[0m"
  send_calypso_request "Eres un experto escritor, con altas capacidades en resumir y obtener puntos principales. Ademas de altas capacidades para redactar textos. Necesito me ayudes a escribir un texto en relacion a: $user_prompt las respuesta deben estar en formato markdown"

done

# Control de Ejecucion
main
