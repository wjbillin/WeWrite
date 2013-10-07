// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: text.proto

#ifndef PROTOBUF_text_2eproto__INCLUDED
#define PROTOBUF_text_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 2005000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 2005000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>
#include <google/protobuf/extension_set.h>
#include <google/protobuf/generated_enum_reflection.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)

// Internal implementation detail -- do not call these.
void  protobuf_AddDesc_text_2eproto();
void protobuf_AssignDesc_text_2eproto();
void protobuf_ShutdownFile_text_2eproto();

class Edit;
class EditSeries;

enum Edit_ChangeType {
  Edit_ChangeType_INSERT = 0,
  Edit_ChangeType_REMOVE = 1,
  Edit_ChangeType_CURSOR = 2
};
bool Edit_ChangeType_IsValid(int value);
const Edit_ChangeType Edit_ChangeType_ChangeType_MIN = Edit_ChangeType_INSERT;
const Edit_ChangeType Edit_ChangeType_ChangeType_MAX = Edit_ChangeType_CURSOR;
const int Edit_ChangeType_ChangeType_ARRAYSIZE = Edit_ChangeType_ChangeType_MAX + 1;

const ::google::protobuf::EnumDescriptor* Edit_ChangeType_descriptor();
inline const ::std::string& Edit_ChangeType_Name(Edit_ChangeType value) {
  return ::google::protobuf::internal::NameOfEnum(
    Edit_ChangeType_descriptor(), value);
}
inline bool Edit_ChangeType_Parse(
    const ::std::string& name, Edit_ChangeType* value) {
  return ::google::protobuf::internal::ParseNamedEnum<Edit_ChangeType>(
    Edit_ChangeType_descriptor(), name, value);
}
// ===================================================================

class Edit : public ::google::protobuf::Message {
 public:
  Edit();
  virtual ~Edit();

  Edit(const Edit& from);

  inline Edit& operator=(const Edit& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const Edit& default_instance();

  void Swap(Edit* other);

  // implements Message ----------------------------------------------

  Edit* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const Edit& from);
  void MergeFrom(const Edit& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  typedef Edit_ChangeType ChangeType;
  static const ChangeType INSERT = Edit_ChangeType_INSERT;
  static const ChangeType REMOVE = Edit_ChangeType_REMOVE;
  static const ChangeType CURSOR = Edit_ChangeType_CURSOR;
  static inline bool ChangeType_IsValid(int value) {
    return Edit_ChangeType_IsValid(value);
  }
  static const ChangeType ChangeType_MIN =
    Edit_ChangeType_ChangeType_MIN;
  static const ChangeType ChangeType_MAX =
    Edit_ChangeType_ChangeType_MAX;
  static const int ChangeType_ARRAYSIZE =
    Edit_ChangeType_ChangeType_ARRAYSIZE;
  static inline const ::google::protobuf::EnumDescriptor*
  ChangeType_descriptor() {
    return Edit_ChangeType_descriptor();
  }
  static inline const ::std::string& ChangeType_Name(ChangeType value) {
    return Edit_ChangeType_Name(value);
  }
  static inline bool ChangeType_Parse(const ::std::string& name,
      ChangeType* value) {
    return Edit_ChangeType_Parse(name, value);
  }

  // accessors -------------------------------------------------------

  // required .Edit.ChangeType type = 1;
  inline bool has_type() const;
  inline void clear_type();
  static const int kTypeFieldNumber = 1;
  inline ::Edit_ChangeType type() const;
  inline void set_type(::Edit_ChangeType value);

  // optional string text = 2;
  inline bool has_text() const;
  inline void clear_text();
  static const int kTextFieldNumber = 2;
  inline const ::std::string& text() const;
  inline void set_text(const ::std::string& value);
  inline void set_text(const char* value);
  inline void set_text(const char* value, size_t size);
  inline ::std::string* mutable_text();
  inline ::std::string* release_text();
  inline void set_allocated_text(::std::string* text);

  // optional int32 location = 3;
  inline bool has_location() const;
  inline void clear_location();
  static const int kLocationFieldNumber = 3;
  inline ::google::protobuf::int32 location() const;
  inline void set_location(::google::protobuf::int32 value);

  // optional bool isUndo = 4;
  inline bool has_isundo() const;
  inline void clear_isundo();
  static const int kIsUndoFieldNumber = 4;
  inline bool isundo() const;
  inline void set_isundo(bool value);

  // optional bool isRedo = 5;
  inline bool has_isredo() const;
  inline void clear_isredo();
  static const int kIsRedoFieldNumber = 5;
  inline bool isredo() const;
  inline void set_isredo(bool value);

  // @@protoc_insertion_point(class_scope:Edit)
 private:
  inline void set_has_type();
  inline void clear_has_type();
  inline void set_has_text();
  inline void clear_has_text();
  inline void set_has_location();
  inline void clear_has_location();
  inline void set_has_isundo();
  inline void clear_has_isundo();
  inline void set_has_isredo();
  inline void clear_has_isredo();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::std::string* text_;
  int type_;
  ::google::protobuf::int32 location_;
  bool isundo_;
  bool isredo_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(5 + 31) / 32];

  friend void  protobuf_AddDesc_text_2eproto();
  friend void protobuf_AssignDesc_text_2eproto();
  friend void protobuf_ShutdownFile_text_2eproto();

  void InitAsDefaultInstance();
  static Edit* default_instance_;
};
// -------------------------------------------------------------------

class EditSeries : public ::google::protobuf::Message {
 public:
  EditSeries();
  virtual ~EditSeries();

  EditSeries(const EditSeries& from);

  inline EditSeries& operator=(const EditSeries& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const EditSeries& default_instance();

  void Swap(EditSeries* other);

  // implements Message ----------------------------------------------

  EditSeries* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const EditSeries& from);
  void MergeFrom(const EditSeries& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // required int64 user = 1;
  inline bool has_user() const;
  inline void clear_user();
  static const int kUserFieldNumber = 1;
  inline ::google::protobuf::int64 user() const;
  inline void set_user(::google::protobuf::int64 value);

  // repeated .Edit edits = 2;
  inline int edits_size() const;
  inline void clear_edits();
  static const int kEditsFieldNumber = 2;
  inline const ::Edit& edits(int index) const;
  inline ::Edit* mutable_edits(int index);
  inline ::Edit* add_edits();
  inline const ::google::protobuf::RepeatedPtrField< ::Edit >&
      edits() const;
  inline ::google::protobuf::RepeatedPtrField< ::Edit >*
      mutable_edits();

  // @@protoc_insertion_point(class_scope:EditSeries)
 private:
  inline void set_has_user();
  inline void clear_has_user();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::int64 user_;
  ::google::protobuf::RepeatedPtrField< ::Edit > edits_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(2 + 31) / 32];

  friend void  protobuf_AddDesc_text_2eproto();
  friend void protobuf_AssignDesc_text_2eproto();
  friend void protobuf_ShutdownFile_text_2eproto();

  void InitAsDefaultInstance();
  static EditSeries* default_instance_;
};
// ===================================================================


// ===================================================================

// Edit

// required .Edit.ChangeType type = 1;
inline bool Edit::has_type() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void Edit::set_has_type() {
  _has_bits_[0] |= 0x00000001u;
}
inline void Edit::clear_has_type() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void Edit::clear_type() {
  type_ = 0;
  clear_has_type();
}
inline ::Edit_ChangeType Edit::type() const {
  return static_cast< ::Edit_ChangeType >(type_);
}
inline void Edit::set_type(::Edit_ChangeType value) {
  assert(::Edit_ChangeType_IsValid(value));
  set_has_type();
  type_ = value;
}

// optional string text = 2;
inline bool Edit::has_text() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void Edit::set_has_text() {
  _has_bits_[0] |= 0x00000002u;
}
inline void Edit::clear_has_text() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void Edit::clear_text() {
  if (text_ != &::google::protobuf::internal::kEmptyString) {
    text_->clear();
  }
  clear_has_text();
}
inline const ::std::string& Edit::text() const {
  return *text_;
}
inline void Edit::set_text(const ::std::string& value) {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  text_->assign(value);
}
inline void Edit::set_text(const char* value) {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  text_->assign(value);
}
inline void Edit::set_text(const char* value, size_t size) {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  text_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* Edit::mutable_text() {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  return text_;
}
inline ::std::string* Edit::release_text() {
  clear_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = text_;
    text_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void Edit::set_allocated_text(::std::string* text) {
  if (text_ != &::google::protobuf::internal::kEmptyString) {
    delete text_;
  }
  if (text) {
    set_has_text();
    text_ = text;
  } else {
    clear_has_text();
    text_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  }
}

// optional int32 location = 3;
inline bool Edit::has_location() const {
  return (_has_bits_[0] & 0x00000004u) != 0;
}
inline void Edit::set_has_location() {
  _has_bits_[0] |= 0x00000004u;
}
inline void Edit::clear_has_location() {
  _has_bits_[0] &= ~0x00000004u;
}
inline void Edit::clear_location() {
  location_ = 0;
  clear_has_location();
}
inline ::google::protobuf::int32 Edit::location() const {
  return location_;
}
inline void Edit::set_location(::google::protobuf::int32 value) {
  set_has_location();
  location_ = value;
}

// optional bool isUndo = 4;
inline bool Edit::has_isundo() const {
  return (_has_bits_[0] & 0x00000008u) != 0;
}
inline void Edit::set_has_isundo() {
  _has_bits_[0] |= 0x00000008u;
}
inline void Edit::clear_has_isundo() {
  _has_bits_[0] &= ~0x00000008u;
}
inline void Edit::clear_isundo() {
  isundo_ = false;
  clear_has_isundo();
}
inline bool Edit::isundo() const {
  return isundo_;
}
inline void Edit::set_isundo(bool value) {
  set_has_isundo();
  isundo_ = value;
}

// optional bool isRedo = 5;
inline bool Edit::has_isredo() const {
  return (_has_bits_[0] & 0x00000010u) != 0;
}
inline void Edit::set_has_isredo() {
  _has_bits_[0] |= 0x00000010u;
}
inline void Edit::clear_has_isredo() {
  _has_bits_[0] &= ~0x00000010u;
}
inline void Edit::clear_isredo() {
  isredo_ = false;
  clear_has_isredo();
}
inline bool Edit::isredo() const {
  return isredo_;
}
inline void Edit::set_isredo(bool value) {
  set_has_isredo();
  isredo_ = value;
}

// -------------------------------------------------------------------

// EditSeries

// required int64 user = 1;
inline bool EditSeries::has_user() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void EditSeries::set_has_user() {
  _has_bits_[0] |= 0x00000001u;
}
inline void EditSeries::clear_has_user() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void EditSeries::clear_user() {
  user_ = GOOGLE_LONGLONG(0);
  clear_has_user();
}
inline ::google::protobuf::int64 EditSeries::user() const {
  return user_;
}
inline void EditSeries::set_user(::google::protobuf::int64 value) {
  set_has_user();
  user_ = value;
}

// repeated .Edit edits = 2;
inline int EditSeries::edits_size() const {
  return edits_.size();
}
inline void EditSeries::clear_edits() {
  edits_.Clear();
}
inline const ::Edit& EditSeries::edits(int index) const {
  return edits_.Get(index);
}
inline ::Edit* EditSeries::mutable_edits(int index) {
  return edits_.Mutable(index);
}
inline ::Edit* EditSeries::add_edits() {
  return edits_.Add();
}
inline const ::google::protobuf::RepeatedPtrField< ::Edit >&
EditSeries::edits() const {
  return edits_;
}
inline ::google::protobuf::RepeatedPtrField< ::Edit >*
EditSeries::mutable_edits() {
  return &edits_;
}


// @@protoc_insertion_point(namespace_scope)

#ifndef SWIG
namespace google {
namespace protobuf {

template <>
inline const EnumDescriptor* GetEnumDescriptor< ::Edit_ChangeType>() {
  return ::Edit_ChangeType_descriptor();
}

}  // namespace google
}  // namespace protobuf
#endif  // SWIG

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_text_2eproto__INCLUDED
