use Test::Nginx::Socket::Lua 'no_plan';

run_tests;

__DATA__

=== TEST 1: Token is invalid. Script must returns a code of response equal 401
--- main_config
    env TOKEN;
    env WEBHOOK;
--- http_config
    server {
        listen 127.0.0.1:80;
    }
--- config
    location /t {
        if ($request_method != "POST") {
            return 400;
        }
        set_by_lua $token 'return os.getenv("TOKEN")';
        set_by_lua $token 'return os.getenv("WEBHOOK")';
        content_by_lua_file ../../src/app.lua;
    }
--- request
POST /t
--- more_headers
Token: invalidToken
--- error_log
--- error_code: 401




=== TEST 2: Token is valid. Json is invalid. Script must returns a code of response equal 400
--- main_config
    env TOKEN;
    env WEBHOOK;
--- http_config
    server {
        listen 127.0.0.1:80;
    }
--- config
    location /t {
        if ($request_method != "POST") {
            return 400;
        }
        set_by_lua $token 'return os.getenv("TOKEN")';
        set_by_lua $webhook 'return os.getenv("WEBHOOK")';
        content_by_lua_file ../../src/app.lua;
    }
--- request
POST /t
{"namespace": "", [""}
--- more_headers
Token: mytoken
--- error_log
--- error_code: 400




=== TEST 3: Namespace is invalid. Script must returns a code of response equal 400
--- main_config
    env TOKEN;
    env WEBHOOK;
--- http_config
    server {
        listen 127.0.0.1:80;
    }
--- config
    location /t {
        if ($request_method != "POST") {
            return 400;
        }
        set_by_lua $token 'return os.getenv("TOKEN")';
        set_by_lua $webhook 'return os.getenv("WEBHOOK")';
        content_by_lua_file ../../src/app.lua;
    }
--- request
POST /t
{"namespace": "qwe.rty"}
--- more_headers
Token: mytoken
--- error_log
--- error_code: 400




=== TEST 4: Project name is invalid. Script must returns a code of response equal 400
--- main_config
    env TOKEN;
    env WEBHOOK;
--- http_config
    server {
        listen 127.0.0.1:80;
    }
--- config
    location /t {
        if ($request_method != "POST") {
            return 400;
        }
        set_by_lua $token 'return os.getenv("TOKEN")';
        set_by_lua $webhook 'return os.getenv("WEBHOOK")';
        content_by_lua_file ../../src/app.lua;
    }
--- request
POST /t
{"namespace": "qwerty", "project_name": "qwe.rty"}
--- more_headers
Token: mytoken
--- error_log
--- error_code: 400




=== TEST 5: Tag is invalid. Script must returns a code of response equal 400
--- main_config
    env TOKEN;
    env WEBHOOK;
--- http_config
    server {
        listen 127.0.0.1:80;
    }
--- config
    location /t {
        if ($request_method != "POST") {
            return 400;
        }
        set_by_lua $token 'return os.getenv("TOKEN")';
        set_by_lua $webhook 'return os.getenv("WEBHOOK")';
        content_by_lua_file ../../src/app.lua;
    }
--- request
POST /t
{"namespace": "qwerty", "project_name": "qwerty", "tag": "qwe.rty"}
--- more_headers
Token: mytoken
--- error_log
--- error_code: 400
