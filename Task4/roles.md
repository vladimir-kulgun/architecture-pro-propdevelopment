| Роль | Права роли | Группы пользователей |
| --- | --- | --- |
| `pro-development:privileged-view` | `get`, `list`, `watch` для `secrets`, `configmaps`, `pods` (namespace-scoped) | `privileged-users` |
| `pro-development:view-only` | `get`, `list`, `watch` для `pods`, `deployments`, `replicasets`, `statefulsets`, `daemonsets`, `services`, `configmaps`, `jobs`, `cronjobs`, `ingresses` (без доступа к `secrets`, cluster-scoped) | `view-only-users` |
| `pro-development:cluster-admin` | полный доступ (`*`) ко всем ресурсам и действиям (cluster-scoped) | `cluster-admin-users` |
