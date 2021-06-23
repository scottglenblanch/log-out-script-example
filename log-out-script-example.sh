#!/usr/bin/env bash

####################################
# Required Input
#   * --log
#     * Options: terminal, file
#       * needs at least one of the options. Both options are possible as well
#     * examples of how to run
#       * output-example.sh --log terminal
#       * output-example.sh --log file
#       * output-example.sh --log terminal file
#       * output-example.sh --log file terminal
####################################
####################################
# Variables

LOG=""
LOG_FILE_PATH=""
HAS_FILE_OPTION=""
HAS_TERMINAL_OPTION=""
IS_VARIABLES_VALID=""

####################################
####################################
# Set Variables

set_log_file_path() {
  LOG_FILE_PATH="./output-example.log"
}

set_log_variable() {
  # The command below will set LOG to the values passed in after --log
  source /dev/stdin <<<"$(curl https://raw.githubusercontent.com/scottglenblanch/bash-argument-parser/main/src/arg-parser.sh)" "$@"
}

set_has_file_option() {
  HAS_FILE_OPTION="$([[ "${LOG}" == *"file"* ]] && echo "true" || echo "false")"
}

set_has_terminal_option() {
  HAS_TERMINAL_OPTION="$([[ "${LOG}" == *"terminal"* ]] && echo "true" || echo "false")"
}

set_is_variables_valid() {
  if [[ "${HAS_FILE_OPTION}" == "true" ]] || [[ "${HAS_TERMINAL_OPTION}" == "true" ]]; then
    IS_VARIABLES_VALID="true"
  else
    IS_VARIABLES_VALID="false"
  fi
}

set_variables() {
  set_log_file_path
  set_log_variable "$@"
  set_has_file_option
  set_has_terminal_option
  set_is_variables_valid
}

####################################
####################################
# Run With Logging

run_with_both_log_to_file_and_terminal() {
  infinite_command | tee "${LOG_FILE_PATH}"
}

run_with_only_log_to_file() {
  infinite_command >> "${LOG_FILE_PATH}" 2>&1 &
}

run_with_only_log_to_terminal() {
  infinite_command
}

run_when_valid() {

  IS_RUN_BOTH="$( [[ "${HAS_TERMINAL_OPTION}" == "true" ]] && [[ "${HAS_TERMINAL_OPTION}" == "true" ]] && echo "true" || echo "false" )"

  if [[ "${IS_RUN_BOTH}" == "true" ]]; then
    run_with_both_log_to_file_and_terminal
  elif [[ "${HAS_FILE_OPTION}" == "true" ]]; then
    run_with_only_log_to_file
  elif [[ "${HAS_TERMINAL_OPTION}" == "true" ]]; then
    run_with_only_log_to_terminal
  fi
}

run_when_not_valid() {
  echo "need input --log [terminal, file]"
}

infinite_command() {
  ping google.com
}

####################################
####################################
# Starts up Script

run() {
  set_variables "$@"

  if [[ "${IS_VARIABLES_VALID}" == "true" ]]; then
    run_when_valid
  else
    run_when_not_valid
  fi
}

run "$@"

####################################


