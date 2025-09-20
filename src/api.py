from fastapi import FastAPI
from auth.controller import router as auth_router
from permissions.controller import perms_router as permissions_router
from panel_access.dashboard_controller import router as check_access_admin_app


def register_routers(app: FastAPI):
    app.include_router(auth_router)
    app.include_router(permissions_router)
    app.include_router(check_access_admin_app)