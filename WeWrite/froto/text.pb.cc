// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: text.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "text.pb.h"

#include <algorithm>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format.h>
// @@protoc_insertion_point(includes)

namespace {

const ::google::protobuf::Descriptor* CursorUpdate_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  CursorUpdate_reflection_ = NULL;
const ::google::protobuf::Descriptor* TextChange_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  TextChange_reflection_ = NULL;
const ::google::protobuf::EnumDescriptor* TextChange_ChangeType_descriptor_ = NULL;

}  // namespace


void protobuf_AssignDesc_text_2eproto() {
  protobuf_AddDesc_text_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "text.proto");
  GOOGLE_CHECK(file != NULL);
  CursorUpdate_descriptor_ = file->message_type(0);
  static const int CursorUpdate_offsets_[2] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(CursorUpdate, user_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(CursorUpdate, position_),
  };
  CursorUpdate_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      CursorUpdate_descriptor_,
      CursorUpdate::default_instance_,
      CursorUpdate_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(CursorUpdate, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(CursorUpdate, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(CursorUpdate));
  TextChange_descriptor_ = file->message_type(1);
  static const int TextChange_offsets_[3] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextChange, user_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextChange, type_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextChange, text_),
  };
  TextChange_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      TextChange_descriptor_,
      TextChange::default_instance_,
      TextChange_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextChange, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(TextChange, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(TextChange));
  TextChange_ChangeType_descriptor_ = TextChange_descriptor_->enum_type(0);
}

namespace {

GOOGLE_PROTOBUF_DECLARE_ONCE(protobuf_AssignDescriptors_once_);
inline void protobuf_AssignDescriptorsOnce() {
  ::google::protobuf::GoogleOnceInit(&protobuf_AssignDescriptors_once_,
                 &protobuf_AssignDesc_text_2eproto);
}

void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    CursorUpdate_descriptor_, &CursorUpdate::default_instance());
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    TextChange_descriptor_, &TextChange::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_text_2eproto() {
  delete CursorUpdate::default_instance_;
  delete CursorUpdate_reflection_;
  delete TextChange::default_instance_;
  delete TextChange_reflection_;
}

void protobuf_AddDesc_text_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n\ntext.proto\".\n\014CursorUpdate\022\014\n\004user\030\001 \002"
    "(\005\022\020\n\010position\030\002 \002(\005\"t\n\nTextChange\022\014\n\004us"
    "er\030\001 \002(\005\022$\n\004type\030\002 \002(\0162\026.TextChange.Chan"
    "geType\022\014\n\004text\030\003 \002(\t\"$\n\nChangeType\022\n\n\006IN"
    "SERT\020\000\022\n\n\006REMOVE\020\001", 178);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "text.proto", &protobuf_RegisterTypes);
  CursorUpdate::default_instance_ = new CursorUpdate();
  TextChange::default_instance_ = new TextChange();
  CursorUpdate::default_instance_->InitAsDefaultInstance();
  TextChange::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_text_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_text_2eproto {
  StaticDescriptorInitializer_text_2eproto() {
    protobuf_AddDesc_text_2eproto();
  }
} static_descriptor_initializer_text_2eproto_;

// ===================================================================

#ifndef _MSC_VER
const int CursorUpdate::kUserFieldNumber;
const int CursorUpdate::kPositionFieldNumber;
#endif  // !_MSC_VER

CursorUpdate::CursorUpdate()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void CursorUpdate::InitAsDefaultInstance() {
}

CursorUpdate::CursorUpdate(const CursorUpdate& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void CursorUpdate::SharedCtor() {
  _cached_size_ = 0;
  user_ = 0;
  position_ = 0;
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

CursorUpdate::~CursorUpdate() {
  SharedDtor();
}

void CursorUpdate::SharedDtor() {
  if (this != default_instance_) {
  }
}

void CursorUpdate::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* CursorUpdate::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return CursorUpdate_descriptor_;
}

const CursorUpdate& CursorUpdate::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_text_2eproto();
  return *default_instance_;
}

CursorUpdate* CursorUpdate::default_instance_ = NULL;

CursorUpdate* CursorUpdate::New() const {
  return new CursorUpdate;
}

void CursorUpdate::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    user_ = 0;
    position_ = 0;
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool CursorUpdate::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // required int32 user = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &user_)));
          set_has_user();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(16)) goto parse_position;
        break;
      }

      // required int32 position = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_position:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &position_)));
          set_has_position();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void CursorUpdate::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // required int32 user = 1;
  if (has_user()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(1, this->user(), output);
  }

  // required int32 position = 2;
  if (has_position()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(2, this->position(), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* CursorUpdate::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // required int32 user = 1;
  if (has_user()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(1, this->user(), target);
  }

  // required int32 position = 2;
  if (has_position()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(2, this->position(), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int CursorUpdate::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // required int32 user = 1;
    if (has_user()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->user());
    }

    // required int32 position = 2;
    if (has_position()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->position());
    }

  }
  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void CursorUpdate::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const CursorUpdate* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const CursorUpdate*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void CursorUpdate::MergeFrom(const CursorUpdate& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_user()) {
      set_user(from.user());
    }
    if (from.has_position()) {
      set_position(from.position());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void CursorUpdate::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void CursorUpdate::CopyFrom(const CursorUpdate& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool CursorUpdate::IsInitialized() const {
  if ((_has_bits_[0] & 0x00000003) != 0x00000003) return false;

  return true;
}

void CursorUpdate::Swap(CursorUpdate* other) {
  if (other != this) {
    std::swap(user_, other->user_);
    std::swap(position_, other->position_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata CursorUpdate::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = CursorUpdate_descriptor_;
  metadata.reflection = CursorUpdate_reflection_;
  return metadata;
}


// ===================================================================

const ::google::protobuf::EnumDescriptor* TextChange_ChangeType_descriptor() {
  protobuf_AssignDescriptorsOnce();
  return TextChange_ChangeType_descriptor_;
}
bool TextChange_ChangeType_IsValid(int value) {
  switch(value) {
    case 0:
    case 1:
      return true;
    default:
      return false;
  }
}

#ifndef _MSC_VER
const TextChange_ChangeType TextChange::INSERT;
const TextChange_ChangeType TextChange::REMOVE;
const TextChange_ChangeType TextChange::ChangeType_MIN;
const TextChange_ChangeType TextChange::ChangeType_MAX;
const int TextChange::ChangeType_ARRAYSIZE;
#endif  // _MSC_VER
#ifndef _MSC_VER
const int TextChange::kUserFieldNumber;
const int TextChange::kTypeFieldNumber;
const int TextChange::kTextFieldNumber;
#endif  // !_MSC_VER

TextChange::TextChange()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void TextChange::InitAsDefaultInstance() {
}

TextChange::TextChange(const TextChange& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void TextChange::SharedCtor() {
  _cached_size_ = 0;
  user_ = 0;
  type_ = 0;
  text_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

TextChange::~TextChange() {
  SharedDtor();
}

void TextChange::SharedDtor() {
  if (text_ != &::google::protobuf::internal::kEmptyString) {
    delete text_;
  }
  if (this != default_instance_) {
  }
}

void TextChange::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* TextChange::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return TextChange_descriptor_;
}

const TextChange& TextChange::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_text_2eproto();
  return *default_instance_;
}

TextChange* TextChange::default_instance_ = NULL;

TextChange* TextChange::New() const {
  return new TextChange;
}

void TextChange::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    user_ = 0;
    type_ = 0;
    if (has_text()) {
      if (text_ != &::google::protobuf::internal::kEmptyString) {
        text_->clear();
      }
    }
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool TextChange::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // required int32 user = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &user_)));
          set_has_user();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(16)) goto parse_type;
        break;
      }

      // required .TextChange.ChangeType type = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_type:
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          if (::TextChange_ChangeType_IsValid(value)) {
            set_type(static_cast< ::TextChange_ChangeType >(value));
          } else {
            mutable_unknown_fields()->AddVarint(2, value);
          }
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(26)) goto parse_text;
        break;
      }

      // required string text = 3;
      case 3: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_text:
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_text()));
          ::google::protobuf::internal::WireFormat::VerifyUTF8String(
            this->text().data(), this->text().length(),
            ::google::protobuf::internal::WireFormat::PARSE);
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void TextChange::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // required int32 user = 1;
  if (has_user()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(1, this->user(), output);
  }

  // required .TextChange.ChangeType type = 2;
  if (has_type()) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      2, this->type(), output);
  }

  // required string text = 3;
  if (has_text()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->text().data(), this->text().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      3, this->text(), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* TextChange::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // required int32 user = 1;
  if (has_user()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(1, this->user(), target);
  }

  // required .TextChange.ChangeType type = 2;
  if (has_type()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      2, this->type(), target);
  }

  // required string text = 3;
  if (has_text()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->text().data(), this->text().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        3, this->text(), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int TextChange::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // required int32 user = 1;
    if (has_user()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->user());
    }

    // required .TextChange.ChangeType type = 2;
    if (has_type()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::EnumSize(this->type());
    }

    // required string text = 3;
    if (has_text()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::StringSize(
          this->text());
    }

  }
  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void TextChange::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const TextChange* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const TextChange*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void TextChange::MergeFrom(const TextChange& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_user()) {
      set_user(from.user());
    }
    if (from.has_type()) {
      set_type(from.type());
    }
    if (from.has_text()) {
      set_text(from.text());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void TextChange::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void TextChange::CopyFrom(const TextChange& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool TextChange::IsInitialized() const {
  if ((_has_bits_[0] & 0x00000007) != 0x00000007) return false;

  return true;
}

void TextChange::Swap(TextChange* other) {
  if (other != this) {
    std::swap(user_, other->user_);
    std::swap(type_, other->type_);
    std::swap(text_, other->text_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata TextChange::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = TextChange_descriptor_;
  metadata.reflection = TextChange_reflection_;
  return metadata;
}


// @@protoc_insertion_point(namespace_scope)

// @@protoc_insertion_point(global_scope)
