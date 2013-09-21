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

class CursorUpdate;
class TextUpdate;

enum TextUpdate_ChangeType {
  TextUpdate_ChangeType_INSERT = 0,
  TextUpdate_ChangeType_REMOVE = 1
};
bool TextUpdate_ChangeType_IsValid(int value);
const TextUpdate_ChangeType TextUpdate_ChangeType_ChangeType_MIN = TextUpdate_ChangeType_INSERT;
const TextUpdate_ChangeType TextUpdate_ChangeType_ChangeType_MAX = TextUpdate_ChangeType_REMOVE;
const int TextUpdate_ChangeType_ChangeType_ARRAYSIZE = TextUpdate_ChangeType_ChangeType_MAX + 1;

const ::google::protobuf::EnumDescriptor* TextUpdate_ChangeType_descriptor();
inline const ::std::string& TextUpdate_ChangeType_Name(TextUpdate_ChangeType value) {
  return ::google::protobuf::internal::NameOfEnum(
    TextUpdate_ChangeType_descriptor(), value);
}
inline bool TextUpdate_ChangeType_Parse(
    const ::std::string& name, TextUpdate_ChangeType* value) {
  return ::google::protobuf::internal::ParseNamedEnum<TextUpdate_ChangeType>(
    TextUpdate_ChangeType_descriptor(), name, value);
}
// ===================================================================

class CursorUpdate : public ::google::protobuf::Message {
 public:
  CursorUpdate();
  virtual ~CursorUpdate();

  CursorUpdate(const CursorUpdate& from);

  inline CursorUpdate& operator=(const CursorUpdate& from) {
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
  static const CursorUpdate& default_instance();

  void Swap(CursorUpdate* other);

  // implements Message ----------------------------------------------

  CursorUpdate* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const CursorUpdate& from);
  void MergeFrom(const CursorUpdate& from);
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

  // required int32 user = 1;
  inline bool has_user() const;
  inline void clear_user();
  static const int kUserFieldNumber = 1;
  inline ::google::protobuf::int32 user() const;
  inline void set_user(::google::protobuf::int32 value);

  // required int32 position = 2;
  inline bool has_position() const;
  inline void clear_position();
  static const int kPositionFieldNumber = 2;
  inline ::google::protobuf::int32 position() const;
  inline void set_position(::google::protobuf::int32 value);

  // @@protoc_insertion_point(class_scope:CursorUpdate)
 private:
  inline void set_has_user();
  inline void clear_has_user();
  inline void set_has_position();
  inline void clear_has_position();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::int32 user_;
  ::google::protobuf::int32 position_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(2 + 31) / 32];

  friend void  protobuf_AddDesc_text_2eproto();
  friend void protobuf_AssignDesc_text_2eproto();
  friend void protobuf_ShutdownFile_text_2eproto();

  void InitAsDefaultInstance();
  static CursorUpdate* default_instance_;
};
// -------------------------------------------------------------------

class TextUpdate : public ::google::protobuf::Message {
 public:
  TextUpdate();
  virtual ~TextUpdate();

  TextUpdate(const TextUpdate& from);

  inline TextUpdate& operator=(const TextUpdate& from) {
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
  static const TextUpdate& default_instance();

  void Swap(TextUpdate* other);

  // implements Message ----------------------------------------------

  TextUpdate* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const TextUpdate& from);
  void MergeFrom(const TextUpdate& from);
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

  typedef TextUpdate_ChangeType ChangeType;
  static const ChangeType INSERT = TextUpdate_ChangeType_INSERT;
  static const ChangeType REMOVE = TextUpdate_ChangeType_REMOVE;
  static inline bool ChangeType_IsValid(int value) {
    return TextUpdate_ChangeType_IsValid(value);
  }
  static const ChangeType ChangeType_MIN =
    TextUpdate_ChangeType_ChangeType_MIN;
  static const ChangeType ChangeType_MAX =
    TextUpdate_ChangeType_ChangeType_MAX;
  static const int ChangeType_ARRAYSIZE =
    TextUpdate_ChangeType_ChangeType_ARRAYSIZE;
  static inline const ::google::protobuf::EnumDescriptor*
  ChangeType_descriptor() {
    return TextUpdate_ChangeType_descriptor();
  }
  static inline const ::std::string& ChangeType_Name(ChangeType value) {
    return TextUpdate_ChangeType_Name(value);
  }
  static inline bool ChangeType_Parse(const ::std::string& name,
      ChangeType* value) {
    return TextUpdate_ChangeType_Parse(name, value);
  }

  // accessors -------------------------------------------------------

  // required int32 user = 1;
  inline bool has_user() const;
  inline void clear_user();
  static const int kUserFieldNumber = 1;
  inline ::google::protobuf::int32 user() const;
  inline void set_user(::google::protobuf::int32 value);

  // required .TextUpdate.ChangeType type = 2;
  inline bool has_type() const;
  inline void clear_type();
  static const int kTypeFieldNumber = 2;
  inline ::TextUpdate_ChangeType type() const;
  inline void set_type(::TextUpdate_ChangeType value);

  // required string text = 3;
  inline bool has_text() const;
  inline void clear_text();
  static const int kTextFieldNumber = 3;
  inline const ::std::string& text() const;
  inline void set_text(const ::std::string& value);
  inline void set_text(const char* value);
  inline void set_text(const char* value, size_t size);
  inline ::std::string* mutable_text();
  inline ::std::string* release_text();
  inline void set_allocated_text(::std::string* text);

  // @@protoc_insertion_point(class_scope:TextUpdate)
 private:
  inline void set_has_user();
  inline void clear_has_user();
  inline void set_has_type();
  inline void clear_has_type();
  inline void set_has_text();
  inline void clear_has_text();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::int32 user_;
  int type_;
  ::std::string* text_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(3 + 31) / 32];

  friend void  protobuf_AddDesc_text_2eproto();
  friend void protobuf_AssignDesc_text_2eproto();
  friend void protobuf_ShutdownFile_text_2eproto();

  void InitAsDefaultInstance();
  static TextUpdate* default_instance_;
};
// ===================================================================


// ===================================================================

// CursorUpdate

// required int32 user = 1;
inline bool CursorUpdate::has_user() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void CursorUpdate::set_has_user() {
  _has_bits_[0] |= 0x00000001u;
}
inline void CursorUpdate::clear_has_user() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void CursorUpdate::clear_user() {
  user_ = 0;
  clear_has_user();
}
inline ::google::protobuf::int32 CursorUpdate::user() const {
  return user_;
}
inline void CursorUpdate::set_user(::google::protobuf::int32 value) {
  set_has_user();
  user_ = value;
}

// required int32 position = 2;
inline bool CursorUpdate::has_position() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void CursorUpdate::set_has_position() {
  _has_bits_[0] |= 0x00000002u;
}
inline void CursorUpdate::clear_has_position() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void CursorUpdate::clear_position() {
  position_ = 0;
  clear_has_position();
}
inline ::google::protobuf::int32 CursorUpdate::position() const {
  return position_;
}
inline void CursorUpdate::set_position(::google::protobuf::int32 value) {
  set_has_position();
  position_ = value;
}

// -------------------------------------------------------------------

// TextUpdate

// required int32 user = 1;
inline bool TextUpdate::has_user() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void TextUpdate::set_has_user() {
  _has_bits_[0] |= 0x00000001u;
}
inline void TextUpdate::clear_has_user() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void TextUpdate::clear_user() {
  user_ = 0;
  clear_has_user();
}
inline ::google::protobuf::int32 TextUpdate::user() const {
  return user_;
}
inline void TextUpdate::set_user(::google::protobuf::int32 value) {
  set_has_user();
  user_ = value;
}

// required .TextUpdate.ChangeType type = 2;
inline bool TextUpdate::has_type() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void TextUpdate::set_has_type() {
  _has_bits_[0] |= 0x00000002u;
}
inline void TextUpdate::clear_has_type() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void TextUpdate::clear_type() {
  type_ = 0;
  clear_has_type();
}
inline ::TextUpdate_ChangeType TextUpdate::type() const {
  return static_cast< ::TextUpdate_ChangeType >(type_);
}
inline void TextUpdate::set_type(::TextUpdate_ChangeType value) {
  assert(::TextUpdate_ChangeType_IsValid(value));
  set_has_type();
  type_ = value;
}

// required string text = 3;
inline bool TextUpdate::has_text() const {
  return (_has_bits_[0] & 0x00000004u) != 0;
}
inline void TextUpdate::set_has_text() {
  _has_bits_[0] |= 0x00000004u;
}
inline void TextUpdate::clear_has_text() {
  _has_bits_[0] &= ~0x00000004u;
}
inline void TextUpdate::clear_text() {
  if (text_ != &::google::protobuf::internal::kEmptyString) {
    text_->clear();
  }
  clear_has_text();
}
inline const ::std::string& TextUpdate::text() const {
  return *text_;
}
inline void TextUpdate::set_text(const ::std::string& value) {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  text_->assign(value);
}
inline void TextUpdate::set_text(const char* value) {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  text_->assign(value);
}
inline void TextUpdate::set_text(const char* value, size_t size) {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  text_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* TextUpdate::mutable_text() {
  set_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    text_ = new ::std::string;
  }
  return text_;
}
inline ::std::string* TextUpdate::release_text() {
  clear_has_text();
  if (text_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = text_;
    text_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void TextUpdate::set_allocated_text(::std::string* text) {
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


// @@protoc_insertion_point(namespace_scope)

#ifndef SWIG
namespace google {
namespace protobuf {

template <>
inline const EnumDescriptor* GetEnumDescriptor< ::TextUpdate_ChangeType>() {
  return ::TextUpdate_ChangeType_descriptor();
}

}  // namespace google
}  // namespace protobuf
#endif  // SWIG

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_text_2eproto__INCLUDED
