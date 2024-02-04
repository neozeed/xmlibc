#include <stddef.h>
#include <strings.h>

extern char **environ;

char *
getenv(const char *var)
{
  char **env = environ;
	
  while (*env) {
    if (*env[0] = var[0]) {
      int len = index(*env, '=') - *env;

      if (!strncmp (*env, var, len) && !var[len])
       return *env + len + 1;
    }
    env++;
  }

  return 0;
}
