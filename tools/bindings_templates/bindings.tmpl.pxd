# /!\ Autogenerated code, modifications will be lost /!\
# see `tools/generate_bindings.py`

{% from 'class.tmpl.pxd' import render_class_pxd %}
from godot._hazmat.gdnative_api_struct cimport *
from godot._hazmat.gdapi cimport pythonscript_gdapi as gdapi
from godot.aabb cimport AABB
from godot.array cimport Array
from godot.basis cimport Basis
from godot.color cimport Color
from godot.dictionary cimport Dictionary
from godot.node_path cimport NodePath
from godot.plane cimport Plane
from godot.quat cimport Quat
from godot.rect2 cimport Rect2
from godot.rid cimport RID
from godot.transform cimport Transform
from godot.transform2d cimport Transform2D
from godot.vector2 cimport Vector2
from godot.vector3 cimport Vector3
from godot.pool_int_array cimport PoolIntArray
from godot.pool_string_array cimport PoolStringArray

{% for cls in classes %}
{{ render_class_pxd(cls) }}
{% endfor %}
