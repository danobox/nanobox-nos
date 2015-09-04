# -*- mode: bash; tab-width: 2; -*-
# vim: ts=2 sw=2 ft=bash noet

# validate_presence(1)
#
# $1 = field
#
# Validate that a field exists within the boxfile payload and has a value.
# If the check fails, a fatal error will be printed an a non-zero exit
# will be forced.
validate_presence() {
  if [ -z $(payload "$1") ]; then
    label=${1/boxfile_build/}
    print_fatal "value required" "Boxfile 'build' section requires ${label} to exist and have a value to continue"
    exit 1
  fi
}

# validate_in(2)
#
# $1 = field
# $2 = possible values
#
# Validates that if a field exists, the value present falls within a range
# of acceptable options.
validate_in() {
  field=$1
  options=$2
  pass=0

  for option in $options; do
    if [ "$(payload "${field}")" = "$option" ]; then
      pass=1
    fi
  done

  if [ $pass = 0 ]; then
    label=${field/boxfile_build/}
    message_opts=""

    for option in $options; do
      if [ -n $message_opts ]; then
        message_opts="${message_opts}, "
      fi
      message_opts="${message_opts}${option}"
    done

    message="Boxfile 'build' section attribute $label value must be one of the following: ${message_opts}"

    print_fatal "invalid value", "${message}"
    exit 1
  fi
}

# validate_not_in(2)
#
# $1 = field
# $2 = possible values
#
# Validates that if a field exists, the value present falls does not fall
# within a range of options.
validate_not_in() {
  field=$1
  options=$2
  pass=1

  for option in $options; do
    if [ "$(payload "${field}")" = "$option" ]; then
      pass=0
    fi
  done

  if [ $pass = 0 ]; then
    label=${field/boxfile_build/}
    message_opts=""

    for option in $options; do
      if [ -n $message_opts ]; then
        message_opts="${message_opts}, "
      fi
      message_opts="${message_opts}${option}"
    done

    message="Boxfile 'build' section attribute $label value must not be one of the following: ${message_opts}"

    print_fatal "invalid value", "${message}"
    exit 1
  fi
}