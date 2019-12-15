{%- set gd_functions = cook_c_signatures("""
void godot_basis_new_with_rows(godot_basis* r_dest, godot_vector3* p_x_axis, godot_vector3* p_y_axis, godot_vector3* p_z_axis)
void godot_basis_new_with_axis_and_angle(godot_basis* r_dest, godot_vector3* p_axis, godot_real p_phi)
void godot_basis_new_with_euler(godot_basis* r_dest, godot_vector3* p_euler)
void godot_basis_new_with_euler_quat(godot_basis* r_dest, godot_quat* p_euler)
godot_string godot_basis_as_string(godot_basis* p_self)
godot_basis godot_basis_inverse(godot_basis* p_self)
godot_basis godot_basis_transposed(godot_basis* p_self)
godot_basis godot_basis_orthonormalized(godot_basis* p_self)
godot_real godot_basis_determinant(godot_basis* p_self)
godot_basis godot_basis_rotated(godot_basis* p_self, godot_vector3* p_axis, godot_real p_phi)
godot_basis godot_basis_scaled(godot_basis* p_self, godot_vector3* p_scale)
godot_vector3 godot_basis_get_scale(godot_basis* p_self)
godot_vector3 godot_basis_get_euler(godot_basis* p_self)
godot_quat godot_basis_get_quat(godot_basis* p_self)
void godot_basis_set_quat(godot_basis* p_self, godot_quat* p_quat)
void godot_basis_set_axis_angle_scale(godot_basis* p_self, godot_vector3* p_axis, godot_real p_phi, godot_vector3* p_scale)
void godot_basis_set_euler_scale(godot_basis* p_self, godot_vector3* p_euler, godot_vector3* p_scale)
void godot_basis_set_quat_scale(godot_basis* p_self, godot_quat* p_quat, godot_vector3* p_scale)
godot_real godot_basis_tdotx(godot_basis* p_self, godot_vector3* p_with)
godot_real godot_basis_tdoty(godot_basis* p_self, godot_vector3* p_with)
godot_real godot_basis_tdotz(godot_basis* p_self, godot_vector3* p_with)
godot_vector3 godot_basis_xform(godot_basis* p_self, godot_vector3* p_v)
godot_vector3 godot_basis_xform_inv(godot_basis* p_self, godot_vector3* p_v)
godot_int godot_basis_get_orthogonal_index(godot_basis* p_self)
void godot_basis_new(godot_basis* r_dest)
void godot_basis_get_elements(godot_basis* p_self, godot_vector3* p_elements)
godot_vector3 godot_basis_get_axis(godot_basis* p_self, godot_int p_axis)
void godot_basis_set_axis(godot_basis* p_self, godot_int p_axis, godot_vector3* p_value)
godot_vector3 godot_basis_get_row(godot_basis* p_self, godot_int p_row)
void godot_basis_set_row(godot_basis* p_self, godot_int p_row, godot_vector3* p_value)
godot_bool godot_basis_operator_equal(godot_basis* p_self, godot_basis* p_b)
godot_basis godot_basis_operator_add(godot_basis* p_self, godot_basis* p_b)
godot_basis godot_basis_operator_subtract(godot_basis* p_self, godot_basis* p_b)
godot_basis godot_basis_operator_multiply_vector(godot_basis* p_self, godot_basis* p_b)
godot_basis godot_basis_operator_multiply_scalar(godot_basis* p_self, godot_real p_b)
godot_basis godot_basis_slerp(godot_basis* p_self, godot_basis* p_b, godot_real p_t)
""") -%}

{%- block pxd_header -%}
{%- endblock %}
{%- block pyx_header -%}

cdef inline Basis Basis_multiply_vector(Basis self, Basis b):
    cdef Basis ret  = Basis.__new__(Basis)
    ret._gd_data = gdapi.godot_basis_operator_multiply_vector(&self._gd_data, &b._gd_data)
    return ret

cdef inline Basis Basis_multiply_scalar(Basis self, godot_real b):
    cdef Basis ret  = Basis.__new__(Basis)
    ret._gd_data = gdapi.godot_basis_operator_multiply_scalar(&self._gd_data, b)
    return ret

{%- endblock %}

@cython.final
cdef class Basis:
{% block cdef_attributes %}
    cdef godot_basis _gd_data
{% endblock %}

{% block python_defs %}
    def __init__(self, Vector3 x not None=Vector3.RIGHT, Vector3 y not None=Vector3.UP, Vector3 z not None=Vector3.BACK):
        gdapi.godot_basis_new_with_rows(&self._gd_data, &(<Vector3>x)._gd_data, &(<Vector3>y)._gd_data, &(<Vector3>z)._gd_data)

    @staticmethod
    def from_euler(from_):
        try:
            return Basis.new_with_euler(<Vector3?>from_)
        except TypeError:
            pass
        try:
            return Basis.new_with_euler_quat(<Quat?>from_)
        except TypeError:
            raise TypeError('`from_` must be Quat or Vector3')

    @staticmethod
    def from_axis_angle(Vector3 axis not None, phi):
        return Basis.new_with_axis_and_angle(axis, phi)

    def __repr__(self):
        return f"<Basis({self.as_string()})>"

    @property
    def x(self) -> Vector3:
        return gdapi.godot_basis_get_axis(&self._gd_data, 0)

    @x.setter
    def x(self, Vector3 val not None) -> None:
        gdapi.godot_basis_set_axis(&self._gd_data, 0, &val._gd_data)

    @property
    def y(self) -> Vector3:
        return gdapi.godot_basis_get_axis(&self._gd_data, 1)

    @y.setter
    def y(self, Vector3 val not None) -> None:
        gdapi.godot_basis_set_axis(&self._gd_data, 1, &val._gd_data)

    @property
    def z(self) -> Vector3:
        return gdapi.godot_basis_get_axis(&self._gd_data, 2)

    @z.setter
    def z(self, Vector3 val not None) -> None:
        gdapi.godot_basis_set_axis(&self._gd_data, 2, &val._gd_data)

    {{ render_operator_eq() | indent }}
    {{ render_operator_ne() | indent }}

    def __add__(self, Basis val not None):
        cdef Basis ret  = Basis.__new__(Basis)
        ret._gd_data = gdapi.godot_basis_operator_add(&self._gd_data, &val._gd_data)
        return ret

    def __sub__(self, Basis val not None):
        cdef Basis ret  = Basis.__new__(Basis)
        ret._gd_data = gdapi.godot_basis_operator_subtract(&self._gd_data, &val._gd_data)
        return ret

    def __mul__(self, val):
        cdef Basis _val

        try:
            _val = <Basis?>val

        except TypeError:
            return Basis_multiply_scalar(self, val)

        else:
            return Basis_multiply_vector(self, _val)

    {{ render_method(**gd_functions['as_string']) | indent }}
    {{ render_method(**gd_functions['inverse']) | indent }}
    {{ render_method(**gd_functions['transposed']) | indent }}
    {{ render_method(**gd_functions['orthonormalized']) | indent }}
    {{ render_method(**gd_functions['determinant']) | indent }}
    {{ render_method(**gd_functions['rotated']) | indent }}
    {{ render_method(**gd_functions['scaled']) | indent }}
    {{ render_method(**gd_functions['get_scale']) | indent }}
    {{ render_method(**gd_functions['get_euler']) | indent }}
    {{ render_method(**gd_functions['get_quat']) | indent }}
    {{ render_method(**gd_functions['set_quat']) | indent }}
    {{ render_method(**gd_functions['set_axis_angle_scale']) | indent }}
    {{ render_method(**gd_functions['set_euler_scale']) | indent }}
    {{ render_method(**gd_functions['set_quat_scale']) | indent }}
    {{ render_method(**gd_functions['tdotx']) | indent }}
    {{ render_method(**gd_functions['tdoty']) | indent }}
    {{ render_method(**gd_functions['tdotz']) | indent }}
    {{ render_method(**gd_functions['xform']) | indent }}
    {{ render_method(**gd_functions['xform_inv']) | indent }}
    {{ render_method(**gd_functions['get_orthogonal_index']) | indent }}
    {{ render_method(**gd_functions['get_elements']) | indent }}
    {{ render_method(**gd_functions['get_row']) | indent }}
    {{ render_method(**gd_functions['set_row']) | indent }}
    {{ render_method(**gd_functions['slerp']) | indent }}
{% endblock %}
