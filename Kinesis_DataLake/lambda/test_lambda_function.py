import unittest
from lambda_function import lambda_handler

class TestLambdaFunction(unittest.TestCase):
    def test_lambda_handler(self):
        event = {
            'Records': [
                {
                    'kinesis': {
                        'data': '{"event_uuid": "123", "event_name": "account:created", "created_at": 1616161616}'
                    }
                }
            ]
        }
        context = {}
        lambda_handler(event, context)

if __name__ == '__main__':
    unittest.main()
