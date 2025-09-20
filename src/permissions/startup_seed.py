# Liga_CUT/src/panel/startup_seed.py
import os
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from auth.models import User, Permission, UserPermission

PERM_NAME = "admin:panel.access"

async def ensure_panel_access_seed(db: AsyncSession) -> None:
    # 1) Asegurar permiso
    res = await db.execute(select(Permission).where(Permission.name == PERM_NAME))
    perm = res.scalar_one_or_none()
    if not perm:
        perm = Permission(name=PERM_NAME, description="Acceso al panel admin")
        db.add(perm)
        await db.commit()
        await db.refresh(perm)

    # 2) Asignar a SUPERADMINS del .env
    emails = [e.strip().lower() for e in os.getenv("SUPERADMINS", "").split(",") if e.strip()]
    if not emails:
        return
    res = await db.execute(select(User).where(User.email.in_(emails)))
    for u in res.scalars().all():
        if not any(p.name == PERM_NAME for p in u.permissions):
            db.add(UserPermission(user_id=u.id, permission_id=perm.id))
    await db.commit()
