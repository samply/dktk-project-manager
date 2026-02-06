#!/bin/sh

# Export environment variables with base64-encoded content
export EMAIL_CONTEXT_B64SUPPORTMINUSINFO="$(base64 -w 0 /app/templates/support-info.html)"
export EMAIL_CONTEXT_B64TEAMMINUSSIGNATURE="$(base64 -w 0 /app/templates/team-signature.html)"
export EMAIL_CONTEXT_B64PROJECTMINUSVIEWMINUSLINK="$(base64 -w 0 /app/templates/project-view-link.html)"
export EMAIL_CONTEXT_B64RESEARCHMINUSENVIRONMENTMINUSLINK="$(base64 -w 0 /app/templates/research-environment-link.html)"

# Now, run the Java application with the exported environment variables
exec java $JAVA_OPTS -jar /app/project-manager.jar
