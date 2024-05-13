 sealed class CrudException implements Exception {
   final String message;

   CrudException(this.message);

  static CrudException fromException(Exception e) {
    return GenericException(e.toString());
  }
 }

 class GenericException extends CrudException {
   GenericException(String message) : super(message);
 }

 class CreateException extends CrudException {
   CreateException(String message) : super(message);
 }

 class ReadException extends CrudException {
   ReadException(String message) : super(message);
 }

 class UpdateException extends CrudException {
   UpdateException(String message) : super(message);
 }

 class DeleteException extends CrudException {
   DeleteException(String message) : super(message);
 }

 class AlreadyExistsException extends CrudException {
   AlreadyExistsException(String message) : super(message);
 }

  class NotFoundException extends CrudException {
    NotFoundException(String message) : super(message);
  }