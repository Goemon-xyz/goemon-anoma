#!/bin/bash

echo "Compiling GetGoemonIntent.juvix..."
juvix compile anoma GetGoemonIntent.juvix -o anoma-build/GetGoemonIntent.nockma

# Create a simple test resource
echo "Creating a simple test resource..."
RESOURCE_DATA="AQgMilYcBzwhqmHAr5oiosYBAWoY+ADEImStIBkyiBZ2YsfF"
echo $RESOURCE_DATA > anoma-build/test-resource

echo "Testing with the test resource..."
juvix dev anoma prove anoma-build/GetGoemonIntent.nockma --output anoma-build/GetGoemonIntent.proved.nockma --arg base64:anoma-build/test-resource

echo "Printing result..."
juvix dev anoma print-intent-message anoma-build/GetGoemonIntent.proved.nockma 