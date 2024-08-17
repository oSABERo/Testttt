from alembic.migration import MigrationContext
import sqlalchemy
import os

_current_path = os.path.dirname(os.path.abspath(__file__))
_db_path = "sqlite:///{}".format(os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(_current_path))), "data/dcms.db"))

if __name__ == "__main__":
    try:
        engine = sqlalchemy.create_engine(_db_path, connect_args={'check_same_thread': False})
        conn = engine.connect()

        context = MigrationContext.configure(conn)
        current_rev = context.get_current_revision()
    except Exception:
        print("Error")
    else:
        print(current_rev)