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

const ::google::protobuf::Descriptor* Edit_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  Edit_reflection_ = NULL;
const ::google::protobuf::EnumDescriptor* Edit_ChangeType_descriptor_ = NULL;
const ::google::protobuf::Descriptor* EditSeries_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  EditSeries_reflection_ = NULL;

}  // namespace


void protobuf_AssignDesc_text_2eproto() {
  protobuf_AddDesc_text_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "text.proto");
  GOOGLE_CHECK(file != NULL);
  Edit_descriptor_ = file->message_type(0);
  static const int Edit_offsets_[5] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, type_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, text_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, location_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, isundo_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, isredo_),
  };
  Edit_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      Edit_descriptor_,
      Edit::default_instance_,
      Edit_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(Edit, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(Edit));
  Edit_ChangeType_descriptor_ = Edit_descriptor_->enum_type(0);
  EditSeries_descriptor_ = file->message_type(1);
  static const int EditSeries_offsets_[2] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(EditSeries, user_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(EditSeries, edits_),
  };
  EditSeries_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      EditSeries_descriptor_,
      EditSeries::default_instance_,
      EditSeries_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(EditSeries, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(EditSeries, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(EditSeries));
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
    Edit_descriptor_, &Edit::default_instance());
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    EditSeries_descriptor_, &EditSeries::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_text_2eproto() {
  delete Edit::default_instance_;
  delete Edit_reflection_;
  delete EditSeries::default_instance_;
  delete EditSeries_reflection_;
}

void protobuf_AddDesc_text_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n\ntext.proto\"\230\001\n\004Edit\022\036\n\004type\030\001 \002(\0162\020.Ed"
    "it.ChangeType\022\014\n\004text\030\002 \001(\t\022\020\n\010location\030"
    "\003 \001(\005\022\016\n\006isUndo\030\004 \001(\010\022\016\n\006isRedo\030\005 \001(\010\"0\n"
    "\nChangeType\022\n\n\006INSERT\020\000\022\n\n\006REMOVE\020\001\022\n\n\006C"
    "URSOR\020\002\"0\n\nEditSeries\022\014\n\004user\030\001 \002(\003\022\024\n\005e"
    "dits\030\002 \003(\0132\005.Edit", 217);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "text.proto", &protobuf_RegisterTypes);
  Edit::default_instance_ = new Edit();
  EditSeries::default_instance_ = new EditSeries();
  Edit::default_instance_->InitAsDefaultInstance();
  EditSeries::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_text_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_text_2eproto {
  StaticDescriptorInitializer_text_2eproto() {
    protobuf_AddDesc_text_2eproto();
  }
} static_descriptor_initializer_text_2eproto_;

// ===================================================================

const ::google::protobuf::EnumDescriptor* Edit_ChangeType_descriptor() {
  protobuf_AssignDescriptorsOnce();
  return Edit_ChangeType_descriptor_;
}
bool Edit_ChangeType_IsValid(int value) {
  switch(value) {
    case 0:
    case 1:
    case 2:
      return true;
    default:
      return false;
  }
}

#ifndef _MSC_VER
const Edit_ChangeType Edit::INSERT;
const Edit_ChangeType Edit::REMOVE;
const Edit_ChangeType Edit::CURSOR;
const Edit_ChangeType Edit::ChangeType_MIN;
const Edit_ChangeType Edit::ChangeType_MAX;
const int Edit::ChangeType_ARRAYSIZE;
#endif  // _MSC_VER
#ifndef _MSC_VER
const int Edit::kTypeFieldNumber;
const int Edit::kTextFieldNumber;
const int Edit::kLocationFieldNumber;
const int Edit::kIsUndoFieldNumber;
const int Edit::kIsRedoFieldNumber;
#endif  // !_MSC_VER

Edit::Edit()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void Edit::InitAsDefaultInstance() {
}

Edit::Edit(const Edit& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void Edit::SharedCtor() {
  _cached_size_ = 0;
  type_ = 0;
  text_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  location_ = 0;
  isundo_ = false;
  isredo_ = false;
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

Edit::~Edit() {
  SharedDtor();
}

void Edit::SharedDtor() {
  if (text_ != &::google::protobuf::internal::kEmptyString) {
    delete text_;
  }
  if (this != default_instance_) {
  }
}

void Edit::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* Edit::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return Edit_descriptor_;
}

const Edit& Edit::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_text_2eproto();
  return *default_instance_;
}

Edit* Edit::default_instance_ = NULL;

Edit* Edit::New() const {
  return new Edit;
}

void Edit::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    type_ = 0;
    if (has_text()) {
      if (text_ != &::google::protobuf::internal::kEmptyString) {
        text_->clear();
      }
    }
    location_ = 0;
    isundo_ = false;
    isredo_ = false;
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool Edit::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // required .Edit.ChangeType type = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          if (::Edit_ChangeType_IsValid(value)) {
            set_type(static_cast< ::Edit_ChangeType >(value));
          } else {
            mutable_unknown_fields()->AddVarint(1, value);
          }
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(18)) goto parse_text;
        break;
      }

      // optional string text = 2;
      case 2: {
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
        if (input->ExpectTag(24)) goto parse_location;
        break;
      }

      // optional int32 location = 3;
      case 3: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_location:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &location_)));
          set_has_location();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(32)) goto parse_isUndo;
        break;
      }

      // optional bool isUndo = 4;
      case 4: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_isUndo:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &isundo_)));
          set_has_isundo();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(40)) goto parse_isRedo;
        break;
      }

      // optional bool isRedo = 5;
      case 5: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_isRedo:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &isredo_)));
          set_has_isredo();
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

void Edit::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // required .Edit.ChangeType type = 1;
  if (has_type()) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      1, this->type(), output);
  }

  // optional string text = 2;
  if (has_text()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->text().data(), this->text().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      2, this->text(), output);
  }

  // optional int32 location = 3;
  if (has_location()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(3, this->location(), output);
  }

  // optional bool isUndo = 4;
  if (has_isundo()) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(4, this->isundo(), output);
  }

  // optional bool isRedo = 5;
  if (has_isredo()) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(5, this->isredo(), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* Edit::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // required .Edit.ChangeType type = 1;
  if (has_type()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      1, this->type(), target);
  }

  // optional string text = 2;
  if (has_text()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->text().data(), this->text().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        2, this->text(), target);
  }

  // optional int32 location = 3;
  if (has_location()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(3, this->location(), target);
  }

  // optional bool isUndo = 4;
  if (has_isundo()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(4, this->isundo(), target);
  }

  // optional bool isRedo = 5;
  if (has_isredo()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(5, this->isredo(), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int Edit::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // required .Edit.ChangeType type = 1;
    if (has_type()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::EnumSize(this->type());
    }

    // optional string text = 2;
    if (has_text()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::StringSize(
          this->text());
    }

    // optional int32 location = 3;
    if (has_location()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->location());
    }

    // optional bool isUndo = 4;
    if (has_isundo()) {
      total_size += 1 + 1;
    }

    // optional bool isRedo = 5;
    if (has_isredo()) {
      total_size += 1 + 1;
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

void Edit::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const Edit* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const Edit*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void Edit::MergeFrom(const Edit& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_type()) {
      set_type(from.type());
    }
    if (from.has_text()) {
      set_text(from.text());
    }
    if (from.has_location()) {
      set_location(from.location());
    }
    if (from.has_isundo()) {
      set_isundo(from.isundo());
    }
    if (from.has_isredo()) {
      set_isredo(from.isredo());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void Edit::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void Edit::CopyFrom(const Edit& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool Edit::IsInitialized() const {
  if ((_has_bits_[0] & 0x00000001) != 0x00000001) return false;

  return true;
}

void Edit::Swap(Edit* other) {
  if (other != this) {
    std::swap(type_, other->type_);
    std::swap(text_, other->text_);
    std::swap(location_, other->location_);
    std::swap(isundo_, other->isundo_);
    std::swap(isredo_, other->isredo_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata Edit::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = Edit_descriptor_;
  metadata.reflection = Edit_reflection_;
  return metadata;
}


// ===================================================================

#ifndef _MSC_VER
const int EditSeries::kUserFieldNumber;
const int EditSeries::kEditsFieldNumber;
#endif  // !_MSC_VER

EditSeries::EditSeries()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void EditSeries::InitAsDefaultInstance() {
}

EditSeries::EditSeries(const EditSeries& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void EditSeries::SharedCtor() {
  _cached_size_ = 0;
  user_ = GOOGLE_LONGLONG(0);
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

EditSeries::~EditSeries() {
  SharedDtor();
}

void EditSeries::SharedDtor() {
  if (this != default_instance_) {
  }
}

void EditSeries::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* EditSeries::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return EditSeries_descriptor_;
}

const EditSeries& EditSeries::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_text_2eproto();
  return *default_instance_;
}

EditSeries* EditSeries::default_instance_ = NULL;

EditSeries* EditSeries::New() const {
  return new EditSeries;
}

void EditSeries::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    user_ = GOOGLE_LONGLONG(0);
  }
  edits_.Clear();
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool EditSeries::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // required int64 user = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int64, ::google::protobuf::internal::WireFormatLite::TYPE_INT64>(
                 input, &user_)));
          set_has_user();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(18)) goto parse_edits;
        break;
      }

      // repeated .Edit edits = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_edits:
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
                input, add_edits()));
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(18)) goto parse_edits;
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

void EditSeries::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // required int64 user = 1;
  if (has_user()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt64(1, this->user(), output);
  }

  // repeated .Edit edits = 2;
  for (int i = 0; i < this->edits_size(); i++) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      2, this->edits(i), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* EditSeries::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // required int64 user = 1;
  if (has_user()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArray(1, this->user(), target);
  }

  // repeated .Edit edits = 2;
  for (int i = 0; i < this->edits_size(); i++) {
    target = ::google::protobuf::internal::WireFormatLite::
      WriteMessageNoVirtualToArray(
        2, this->edits(i), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int EditSeries::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // required int64 user = 1;
    if (has_user()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int64Size(
          this->user());
    }

  }
  // repeated .Edit edits = 2;
  total_size += 1 * this->edits_size();
  for (int i = 0; i < this->edits_size(); i++) {
    total_size +=
      ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
        this->edits(i));
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

void EditSeries::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const EditSeries* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const EditSeries*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void EditSeries::MergeFrom(const EditSeries& from) {
  GOOGLE_CHECK_NE(&from, this);
  edits_.MergeFrom(from.edits_);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_user()) {
      set_user(from.user());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void EditSeries::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void EditSeries::CopyFrom(const EditSeries& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool EditSeries::IsInitialized() const {
  if ((_has_bits_[0] & 0x00000001) != 0x00000001) return false;

  for (int i = 0; i < edits_size(); i++) {
    if (!this->edits(i).IsInitialized()) return false;
  }
  return true;
}

void EditSeries::Swap(EditSeries* other) {
  if (other != this) {
    std::swap(user_, other->user_);
    edits_.Swap(&other->edits_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata EditSeries::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = EditSeries_descriptor_;
  metadata.reflection = EditSeries_reflection_;
  return metadata;
}


// @@protoc_insertion_point(namespace_scope)

// @@protoc_insertion_point(global_scope)
