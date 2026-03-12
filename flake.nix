{
  description = "A Nix-flake-based development environment for springboot-demo";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit self system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [ postgresql_17 ];
          shellHook = ''
            export PGDATA="$PWD/postgres_data"
            export PGPORT=5433
            if [ ! -d "$PGDATA" ]; then
              initdb -D "$PGDATA"
              echo "port = 5433" >> "$PGDATA/postgresql.conf"
              echo "unix_socket_directories = '$PGDATA'" >> "$PGDATA/postgresql.conf"
            fi
            pg_ctl -D "$PGDATA" start -l "$PGDATA/logfile" || true
            sleep 1
            psql -p 5433 -c "CREATE USER brant WITH PASSWORD 'password' CREATEDB;" postgres 2>/dev/null || true
            psql -p 5433 -c "CREATE DATABASE testdb OWNER brant;" postgres 2>/dev/null || true
            echo "PostgreSQL started on port 5433"
          '';
        };
      });
    };
}
