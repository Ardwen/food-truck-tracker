from flask_restx import Namespace, fields

class VendorDto:
    api = Namespace('vendor', description='vendor related operations')
    location = api.model('location', {
    	'lat': fields.Float(required=True),
    	'lng': fields.Float(required=True),
    	})
    schedule = api.model('schedule', {
    	'start': fields.DateTime(required=True),
    	'end': fields.DateTime(required=True),
    	})
    vendor = api.model('vendor', {
        'displayed_name': fields.String(description='vendor displayed name'),
        'username': fields.String(required=True, description='vendor username'),
        'location': fields.Nested(location, description='vendor location'),
        'schedule': fields.Nested(schedule, description='vendor schedule'),
        'tags': fields.List(fields.String),
        'is_open': fields.Boolean(readonly=True, description='is vendor open'),
    })
    vendor_detail = api.inherit('vendor_detail', vendor, {
        'description': fields.String(description='vendor description'),
    })
